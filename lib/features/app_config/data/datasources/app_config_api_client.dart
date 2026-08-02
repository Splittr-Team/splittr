import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/app_config/data/models/app_config_response_model.dart';

part 'app_config_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/app-config')
abstract class AppConfigApiClient {
  @factoryMethod
  factory AppConfigApiClient(Dio dio) = _AppConfigApiClient;

  @GET('')
  Future<HttpResponse<AppConfigResponseModel>> getAppConfig({
    @Header('If-None-Match') String? etag,
  });
}
