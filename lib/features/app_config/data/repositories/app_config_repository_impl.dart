import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/app_config/data/datasources/app_config_local_data_source.dart';
import 'package:splittr/features/app_config/data/datasources/app_config_remote_data_source.dart';
import 'package:splittr/features/app_config/data/mappers/app_config_isar_to_domain.dart';
import 'package:splittr/features/app_config/data/mappers/app_config_model_to_domain.dart';
import 'package:splittr/features/app_config/data/mappers/app_config_model_to_isar.dart';
import 'package:splittr/features/app_config/domain/entities/app_config.dart';
import 'package:splittr/features/app_config/domain/repositories/app_config_repository.dart';

@LazySingleton(as: AppConfigRepository)
final class AppConfigRepositoryImpl implements AppConfigRepository {
  AppConfigRepositoryImpl(
    this._apiCallHandler,
    this._remoteDataSource,
    this._localDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final AppConfigRemoteDataSource _remoteDataSource;
  final AppConfigLocalDataSource _localDataSource;

  @override
  FutureEitherFailure<AppConfig> getAppConfig() async {
    final localCache = await _localDataSource.getCachedConfig();
    final savedETag = localCache?.etag;

    final result = await _apiCallHandler.handle(
      () => _remoteDataSource.getAppConfig(etag: savedETag),
    );

    return result.fold(
      (failure) async {
        if (localCache != null) {
          return Right(localCache.toDomain());
        }
        return Left(failure);
      },
      (httpResponse) async {
        if (httpResponse.response.statusCode == 304 && localCache != null) {
          return Right(localCache.toDomain());
        }

        final responseModel = httpResponse.data;
        final responseETag =
            httpResponse.response.headers.value('etag') ??
            responseModel.meta?.configVersion ??
            '';

        final isarModel = responseModel.toIsar(etag: responseETag);
        await _localDataSource.saveConfig(isarModel);

        return Right(responseModel.toDomain());
      },
    );
  }
}
