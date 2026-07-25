import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/friends/data/datasources/friends_local_data_source.dart';
import 'package:splittr/features/friends/data/models/friend_isar_model.dart';

@LazySingleton(as: FriendsLocalDataSource)
class FriendsLocalDataSourceImpl implements FriendsLocalDataSource {
  FriendsLocalDataSourceImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<FriendIsarModel>> watchFriends() {
    return _isar.friendIsarModels.where().sortByCreatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  @override
  Future<List<FriendIsarModel>> getFriends({int? limit}) async {
    final query = _isar.friendIsarModels.where().sortByCreatedAtDesc();
    if (limit != null) {
      return query.limit(limit).findAll();
    }
    return query.findAll();
  }

  @override
  Future<void> saveFriend(FriendIsarModel friend) async {
    await _isar.writeTxn(() async {
      await _isar.friendIsarModels.put(friend);
    });
  }

  @override
  Future<void> saveFriends({
    required List<FriendIsarModel> friends,
    required String? nextCursor,
    required bool hasMore,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.friendIsarModels.putAll(friends);

      final meta = PaginationMetadataIsarModel()
        ..featureKey = FeatureCacheKey.friends
        ..nextCursor = nextCursor
        ..hasMore = hasMore
        ..lastSyncedAt = DateTime.now();

      await _isar.paginationMetadataIsarModels.put(meta);
    });
  }

  @override
  Future<PaginationMetadataIsarModel?> getPaginationMetadata(
    FeatureCacheKey featureKey,
  ) async {
    return _isar.paginationMetadataIsarModels
        .filter()
        .featureKeyEqualTo(featureKey)
        .findFirst();
  }

  @override
  Future<void> deleteFriend(String id) async {
    await _isar.writeTxn(() async {
      await _isar.friendIsarModels.filter().idEqualTo(id).deleteAll();
    });
  }
}
