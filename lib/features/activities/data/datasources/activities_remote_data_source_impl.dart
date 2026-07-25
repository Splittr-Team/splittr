import 'package:injectable/injectable.dart';
import 'package:splittr/features/activities/data/datasources/activities_api_client.dart';
import 'package:splittr/features/activities/data/datasources/activities_remote_data_source.dart';
import 'package:splittr/features/activities/data/models/activities_response_model.dart';

@LazySingleton(as: ActivitiesRemoteDataSource)
final class ActivitiesRemoteDataSourceImpl
    implements ActivitiesRemoteDataSource {
  const ActivitiesRemoteDataSourceImpl(this._apiClient);

  final ActivitiesApiClient _apiClient;

  @override
  Future<ActivitiesResponseModel> getActivities({
    String? cursor,
    int? limit,
  }) {
    return _apiClient.getActivities(cursor: cursor, limit: limit);
  }

  @override
  Future<ActivitiesResponseModel> getGroupFeed({
    required String groupId,
    String? cursor,
    int? limit,
  }) {
    return _apiClient.getGroupFeed(groupId, cursor: cursor, limit: limit);
  }
}
