import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_devtools/sky_devtools.dart';
import 'package:sky_router/sky_router.dart';
import 'package:sky_telemetry/sky_telemetry.dart';
import 'package:splittr/constants/env/env.dart';
import 'package:splittr/core/app_config/i_app_config.dart';
import 'package:splittr/core/router/app_router.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  AppLogger get appLogger {
    final logging = AppLoggerRegistry.instance..register(ConsoleLogger());

    if (appConfig.env == Env.dev) {
      final talker = TalkerFlutter.init(
        settings: TalkerSettings(
          useConsoleLogs: false,
        ),
      );
      logging.register(TalkerAppLogger(talker));
    }

    return logging;
  }

  @lazySingleton
  GoRouter get goRouter => createAppRouter(
    authBloc: getIt<AuthBloc>(),
    logger: appLogger,
  );
}
