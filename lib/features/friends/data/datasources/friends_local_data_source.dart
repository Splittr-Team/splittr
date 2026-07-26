import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/friends/data/models/friend_isar_model.dart';

abstract interface class FriendsLocalDataSource {
  Stream<List<FriendIsarModel>> watchFriends();

  Future<List<FriendIsarModel>> getFriends({int? limit});

  Future<void> saveFriend(FriendIsarModel friend);

  Future<void> saveFriends({
    required List<FriendIsarModel> friends,
    required String? nextCursor,
    required bool hasMore,
  });

  Future<PaginationMetadataIsarModel?> getPaginationMetadata(
    FeatureCacheKey featureKey,
  );

  Future<void> deleteFriend(String id);
}
