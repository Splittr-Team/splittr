import 'package:retrofit/retrofit.dart';
import 'package:splittr/features/app_config/data/models/app_config_response_model.dart';

abstract interface class AppConfigRemoteDataSource {
  Future<HttpResponse<AppConfigResponseModel>> getAppConfig({String? etag});
}
