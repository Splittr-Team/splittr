import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:splittr/features/app_config/data/datasources/app_config_api_client.dart';
import 'package:splittr/features/app_config/data/datasources/app_config_remote_data_source.dart';
import 'package:splittr/features/app_config/data/models/app_config_response_model.dart';

@LazySingleton(as: AppConfigRemoteDataSource)
final class AppConfigRemoteDataSourceImpl implements AppConfigRemoteDataSource {
  const AppConfigRemoteDataSourceImpl(this._apiClient);

  final AppConfigApiClient _apiClient;

  @override
  Future<HttpResponse<AppConfigResponseModel>> getAppConfig({String? etag}) {
    return _apiClient.getAppConfig(etag: etag);
  }
}
