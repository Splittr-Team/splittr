import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/friends/data/datasources/friends_local_data_source.dart';
import 'package:splittr/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:splittr/features/friends/data/mappers/friend_mappers.dart';
import 'package:splittr/features/friends/data/models/friend_isar_model.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';
import 'package:splittr/features/sync/data/datasources/outbox_local_data_source.dart';
import 'package:splittr/features/sync/data/models/outbox_action_isar_model.dart';
import 'package:splittr/features/sync/domain/models/outbox_action_types.dart';
import 'package:splittr/features/sync/domain/services/outbox_worker.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: FriendsRepository)
final class FriendsRepositoryImpl implements FriendsRepository {
  FriendsRepositoryImpl(
    this._apiCallHandler,
    this._friendsRemoteDataSource,
    this._friendsLocalDataSource,
    this._outboxLocalDataSource,
    this._outboxWorker,
  );

  final ApiCallHandler _apiCallHandler;
  final FriendsRemoteDataSource _friendsRemoteDataSource;
  final FriendsLocalDataSource _friendsLocalDataSource;
  final OutboxLocalDataSource _outboxLocalDataSource;
  final OutboxWorker _outboxWorker;
  final Mutex _syncLock = Mutex();

  @override
  Stream<EitherFailure<List<Friend>>> watchFriends() => _friendsLocalDataSource
      .watchFriends()
      .map((models) => Right(models.toDomain()));

  @override
  FutureEitherFailure<PaginatedList<Friend>> getFriends({
    String? cursor,
    int? limit,
    FriendshipStatus? status,
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
          status: status,
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
  FutureEitherFailure<Friend> addFriend({
    String? friendEmail,
    String? friendPhone,
  }) async {
    final tempId = 'temp-${const Uuid().v4()}';
    final idempotencyKey = const Uuid().v4();
    final now = DateTime.now();

    final optimisticFriend = FriendIsarModel()
      ..id = tempId
      ..email = friendEmail
      ..phone = friendPhone
      ..name = friendEmail ?? friendPhone ?? 'Friend'
      ..status = 'pending'
      ..createdAt = now
      ..updatedAt = now;

    await _friendsLocalDataSource.saveFriend(optimisticFriend);

    final payload = <String, dynamic>{
      'friendEmail': ?friendEmail,
      'friendPhone': ?friendPhone,
    };

    final action = OutboxActionIsarModel()
      ..actionType = OutboxActionTypes.addFriend
      ..idempotencyKey = idempotencyKey
      ..tempId = tempId
      ..payloadJson = jsonEncode(payload)
      ..createdAt = now;

    await _outboxLocalDataSource.enqueue(action);
    _outboxWorker.flush().ignore();

    return Right(optimisticFriend.toDomain());
  }

  @override
  FutureEitherFailure<Friend> updateFriendshipStatus({
    required String friendId,
    required FriendshipStatus status,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _friendsRemoteDataSource.updateFriendshipStatus(
        friendId: friendId,
        status: status,
      ),
    );
    return result.map((model) => model.toDomain());
  }

  @override
  FutureEitherFailure<Unit> removeFriend(String friendId) async {
    final idempotencyKey = const Uuid().v4();
    final now = DateTime.now();

    await _friendsLocalDataSource.deleteFriend(friendId);

    final action = OutboxActionIsarModel()
      ..actionType = OutboxActionTypes.removeFriend
      ..idempotencyKey = idempotencyKey
      ..tempId = friendId.startsWith('temp-') ? friendId : null
      ..payloadJson = jsonEncode({'friendId': friendId})
      ..createdAt = now;

    await _outboxLocalDataSource.enqueue(action);
    _outboxWorker.flush().ignore();

    return const Right(unit);
  }
}
