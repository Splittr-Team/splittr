import 'package:splittr/features/activities/data/models/activities_response_model.dart';

abstract interface class ActivitiesRemoteDataSource {
  Future<ActivitiesResponseModel> getActivities({
    String? cursor,
    int? limit,
  });

  Future<ActivitiesResponseModel> getGroupFeed({
    required String groupId,
    String? cursor,
    int? limit,
  });
}
