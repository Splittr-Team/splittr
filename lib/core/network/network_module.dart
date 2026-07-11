import 'package:injectable/injectable.dart';
import 'package:sky_devtools/sky_devtools.dart';
import 'package:sky_network/sky_network.dart';
import 'package:sky_telemetry/sky_telemetry.dart';
import 'package:splittr/constants/env/env.dart';
import 'package:splittr/core/app_config/i_app_config.dart';
import 'package:splittr/core/firebase/firebase_auth_interceptor.dart';

@module
abstract class NetworkModule {
  static const _vercelBypassHeaderKey = 'x-vercel-protection-bypass';

  @lazySingleton
  DioFactory get dioFactory => const DioFactoryImpl();

  @lazySingleton
  NetworkOptions get networkOptions => NetworkOptions(
    baseUrl: appConfig.apiBaseUrl,
    enableLogging: appConfig.env == Env.dev,
    headers: {
      _vercelBypassHeaderKey: appConfig.vercelBypassKey,
    },
  );

  @Named('retryDio')
  @lazySingleton
  Dio retryDio(DioFactory dioFactory, NetworkOptions options) {
    return dioFactory.create(options: options);
  }

  @lazySingleton
  Dio dio(
    DioFactory dioFactory,
    NetworkOptions options,
    FirebaseAuthInterceptor authInterceptor,
  ) {
    final interceptors = <Interceptor>[
      authInterceptor,
    ];

    if (appConfig.env == Env.dev) {
      final talkerLogger = AppLoggerRegistry.instance.loggers
          .whereType<TalkerAppLogger>()
          .firstOrNull;

      if (talkerLogger != null) {
        interceptors.add(
          StructuredTalkerDioInterceptor(
            talkerLogger.talker,
          ),
        );
      }
    }

    return dioFactory.create(
      options: options,
      interceptors: interceptors,
    );
  }

  @lazySingleton
  ApiCallHandler get apiCallHandler => const ApiCallHandlerImpl();
}
