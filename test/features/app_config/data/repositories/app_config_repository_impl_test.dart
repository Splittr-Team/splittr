import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/app_config/data/datasources/app_config_local_data_source.dart';
import 'package:splittr/features/app_config/data/datasources/app_config_remote_data_source.dart';
import 'package:splittr/features/app_config/data/models/app_config_isar_model.dart';
import 'package:splittr/features/app_config/data/models/app_config_response_model.dart';
import 'package:splittr/features/app_config/data/repositories/app_config_repository_impl.dart';

class MockApiCallHandler extends Mock implements ApiCallHandler {}

class MockAppConfigRemoteDataSource extends Mock
    implements AppConfigRemoteDataSource {}

class MockAppConfigLocalDataSource extends Mock
    implements AppConfigLocalDataSource {}

void main() {
  late MockApiCallHandler mockApiCallHandler;
  late MockAppConfigRemoteDataSource mockRemoteDataSource;
  late MockAppConfigLocalDataSource mockLocalDataSource;
  late AppConfigRepositoryImpl repository;

  setUp(() {
    mockApiCallHandler = MockApiCallHandler();
    mockRemoteDataSource = MockAppConfigRemoteDataSource();
    mockLocalDataSource = MockAppConfigLocalDataSource();

    repository = AppConfigRepositoryImpl(
      mockApiCallHandler,
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  test(
    'getAppConfig returns local cached domain on 304 Not Modified',
    () async {
      final cachedIsar = AppConfigIsarModel()
        ..id = 0
        ..etag = 'v1.0.0-initial'
        ..system = (SystemConfigIsarModel()
          ..appVersion = (AppVersionIsarModel()
            ..minSupportedVersion = '1.0.0'
            ..latestVersion = '1.2.0'
            ..forceUpdate = false
            ..updateUrl = (UpdateUrlIsarModel()
              ..ios = 'a'
              ..android = 'b')
            ..updateMessage = 'Msg')
          ..maintenance = (MaintenanceIsarModel()
            ..inMaintenance = false
            ..readOnlyMode = false
            ..message = 'M'))
        ..featureFlags = (FeatureFlagsIsarModel()
          ..enableOcrReceiptScan = true
          ..enableSettlementReminders = true
          ..enableExportPdf = true
          ..enableGroupAnalytics = false);

      when(
        () => mockLocalDataSource.getCachedConfig(),
      ).thenAnswer((_) async => cachedIsar);

      final dioResponse = Response<dynamic>(
        statusCode: 304,
        requestOptions: RequestOptions(path: '/'),
      );
      final httpResponse = HttpResponse<AppConfigResponseModel>(
        const AppConfigResponseModel(),
        dioResponse,
      );

      when(
        () => mockRemoteDataSource.getAppConfig(etag: 'v1.0.0-initial'),
      ).thenAnswer((_) async => httpResponse);

      when(
        () => mockApiCallHandler.handle<HttpResponse<AppConfigResponseModel>>(
          any(),
        ),
      ).thenAnswer((invocation) async {
        final callback =
            invocation.positionalArguments[0]
                as Future<HttpResponse<AppConfigResponseModel>> Function();
        final res = await callback();
        return Right(res);
      });

      final result = await repository.getAppConfig();

      expect(result.isRight(), isTrue);
      result.fold(
        (f) => fail('Should succeed'),
        (config) {
          expect(config.system.appVersion.minSupportedVersion, '1.0.0');
          expect(config.configVersion, 'v1.0.0-initial');
        },
      );
    },
  );
}
