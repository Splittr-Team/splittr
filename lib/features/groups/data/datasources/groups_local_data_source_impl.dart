import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/groups/data/datasources/groups_local_data_source.dart';
import 'package:splittr/features/groups/data/models/group_isar_model.dart';

@LazySingleton(as: GroupsLocalDataSource)
class GroupsLocalDataSourceImpl implements GroupsLocalDataSource {
  GroupsLocalDataSourceImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<GroupIsarModel>> watchGroups() {
    return _isar.groupIsarModels.where().sortByCreatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  @override
  Future<List<GroupIsarModel>> getGroups({int? limit}) async {
    final query = _isar.groupIsarModels.where().sortByCreatedAtDesc();
    if (limit != null) {
      return query.limit(limit).findAll();
    }
    return query.findAll();
  }

  @override
  Future<void> saveGroup(GroupIsarModel group) async {
    await _isar.writeTxn(() async {
      await _isar.groupIsarModels.put(group);
    });
  }

  @override
  Future<void> saveGroups({
    required List<GroupIsarModel> groups,
    required String? nextCursor,
    required bool hasMore,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.groupIsarModels.putAll(groups);

      final meta = PaginationMetadataIsarModel()
        ..featureKey = FeatureCacheKey.groups
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
  Future<void> deleteGroup(String id) async {
    await _isar.writeTxn(() async {
      await _isar.groupIsarModels.filter().idEqualTo(id).deleteAll();
    });
  }
}
