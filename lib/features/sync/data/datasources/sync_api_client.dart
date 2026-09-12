import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/sync/data/models/sync_response_model.dart';

part 'sync_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1')
abstract class SyncApiClient {
  @factoryMethod
  factory SyncApiClient(Dio dio) = _SyncApiClient;

  @GET('/sync')
  Future<SyncResponseModel> getSync({
    @Query('friendsVersion') int? friendsVersion,
    @Query('groupsVersion') int? groupsVersion,
    @Query('expensesVersion') int? expensesVersion,
    @Query('limit') int? limit,
  });
}
