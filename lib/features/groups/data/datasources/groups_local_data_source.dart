import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/groups/data/models/group_isar_model.dart';

abstract interface class GroupsLocalDataSource {
  Stream<List<GroupIsarModel>> watchGroups();

  Future<List<GroupIsarModel>> getGroups({int? limit});

  Future<void> saveGroup(GroupIsarModel group);

  Future<void> saveGroups({
    required List<GroupIsarModel> groups,
    required String? nextCursor,
    required bool hasMore,
  });

  Future<PaginationMetadataIsarModel?> getPaginationMetadata(
    FeatureCacheKey featureKey,
  );

  Future<void> deleteGroup(String id);
}
