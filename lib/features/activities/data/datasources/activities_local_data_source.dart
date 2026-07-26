import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/activities/data/models/activity_isar_model.dart';

abstract interface class ActivitiesLocalDataSource {
  Stream<List<ActivityIsarModel>> watchActivities({String? groupId});

  Future<List<ActivityIsarModel>> getActivities({String? groupId, int? limit});

  Future<void> saveActivity(ActivityIsarModel activity);

  Future<void> saveActivities({
    required List<ActivityIsarModel> activities,
    required String? nextCursor,
    required bool hasMore,
  });

  Future<PaginationMetadataIsarModel?> getPaginationMetadata(
    FeatureCacheKey featureKey,
  );
}
