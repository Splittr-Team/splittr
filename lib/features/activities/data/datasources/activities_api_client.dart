import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/activities/data/models/activities_response_model.dart';

part 'activities_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1')
abstract class ActivitiesApiClient {
  @factoryMethod
  factory ActivitiesApiClient(Dio dio) = _ActivitiesApiClient;

  @GET('/activities')
  Future<ActivitiesResponseModel> getActivities({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @GET('/groups/{id}/feed')
  Future<ActivitiesResponseModel> getGroupFeed(
    @Path('id') String id, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });
}
