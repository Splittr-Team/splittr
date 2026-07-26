import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/activities/data/datasources/activities_local_data_source.dart';
import 'package:splittr/features/activities/data/models/activity_isar_model.dart';

@LazySingleton(as: ActivitiesLocalDataSource)
class ActivitiesLocalDataSourceImpl implements ActivitiesLocalDataSource {
  ActivitiesLocalDataSourceImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<ActivityIsarModel>> watchActivities({String? groupId}) {
    if (groupId != null) {
      return _isar.activityIsarModels
          .filter()
          .groupIdEqualTo(groupId)
          .sortByCreatedAtDesc()
          .watch(fireImmediately: true);
    }
    return _isar.activityIsarModels.where().sortByCreatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  @override
  Future<List<ActivityIsarModel>> getActivities({
    String? groupId,
    int? limit,
  }) async {
    final query = groupId != null
        ? _isar.activityIsarModels
              .filter()
              .groupIdEqualTo(groupId)
              .sortByCreatedAtDesc()
        : _isar.activityIsarModels.where().sortByCreatedAtDesc();

    if (limit != null) {
      return query.limit(limit).findAll();
    }
    return query.findAll();
  }

  @override
  Future<void> saveActivity(ActivityIsarModel activity) async {
    await _isar.writeTxn(() async {
      await _isar.activityIsarModels.put(activity);
    });
  }

  @override
  Future<void> saveActivities({
    required List<ActivityIsarModel> activities,
    required String? nextCursor,
    required bool hasMore,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.activityIsarModels.putAll(activities);

      final meta = PaginationMetadataIsarModel()
        ..featureKey = FeatureCacheKey.activities
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
}
