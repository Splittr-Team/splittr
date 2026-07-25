import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/auth/data/mappers/user.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/friends/data/datasources/friends_local_data_source.dart';
import 'package:splittr/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:splittr/features/friends/data/mappers/friend_mappers.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';

@LazySingleton(as: FriendsRepository)
final class FriendsRepositoryImpl implements FriendsRepository {
  FriendsRepositoryImpl(
    this._apiCallHandler,
    this._friendsRemoteDataSource,
    this._friendsLocalDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final FriendsRemoteDataSource _friendsRemoteDataSource;
  final FriendsLocalDataSource _friendsLocalDataSource;
  final Mutex _syncLock = Mutex();

  @override
  Stream<EitherFailure<List<User>>> watchFriends() => _friendsLocalDataSource
      .watchFriends()
      .map((models) => Right(models.toDomain()));

  @override
  FutureEitherFailure<PaginatedList<User>> getFriends({
    String? cursor,
    int? limit,
  }) async {
    return _syncLock.protect(() async {
      var effectiveCursor = cursor;

      if (cursor != null) {
        final meta = await _friendsLocalDataSource.getPaginationMetadata(
          FeatureCacheKey.friends,
        );
        if (meta != null && !meta.hasMore) {
          return const Right(
            PaginatedList(
              items: [],
              pagination: Pagination(hasMore: false),
            ),
          );
        }
        effectiveCursor = meta?.nextCursor ?? cursor;
      }

      final result = await _apiCallHandler.handle(
        () => _friendsRemoteDataSource.getFriends(
          cursor: effectiveCursor,
          limit: limit,
        ),
      );

      return result.fold(
        Left.new,
        (response) async {
          final domainFriends = response.data.toDomain();
          final pagination = response.pagination.toDomain();

          await _friendsLocalDataSource.saveFriends(
            friends: response.data.toIsar(),
            nextCursor: pagination.nextCursor,
            hasMore: pagination.hasMore,
          );

          return Right(
            PaginatedList(items: domainFriends, pagination: pagination),
          );
        },
      );
    });
  }

  @override
  FutureEitherFailure<User> addFriend({
    String? friendEmail,
    String? friendPhone,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _friendsRemoteDataSource.addFriend(
        friendEmail: friendEmail,
        friendPhone: friendPhone,
      ),
    );
    return result.map((model) => model.toDomain());
  }

  @override
  FutureEitherFailure<Unit> removeFriend(String friendId) async {
    return _apiCallHandler.handle(
      () => _friendsRemoteDataSource.removeFriend(friendId),
    );
  }
}
