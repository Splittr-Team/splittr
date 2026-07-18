import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppTheme;
import 'package:sky_devtools/sky_devtools.dart';
import 'package:sky_router/sky_router.dart';
import 'package:sky_telemetry/sky_telemetry.dart';
import 'package:splittr/constants/env/env.dart';
import 'package:splittr/core/app_config/i_app_config.dart';
import 'package:splittr/core/bloc/app_bloc_observer.dart';
import 'package:splittr/core/router/app_router.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/l10n/generated/app_localizations.dart';

Future<void> mainCommon(Env env) async {
  appConfig = IAppConfig.init(env);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: appConfig.firebaseOptions);

  await configureDependencies(env);

  // Setup uncaught error logging
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    try {
      getIt<AppLogger>().error(
        details.exceptionAsString(),
        error: details.exception,
        stackTrace: details.stack,
      );
    } on Object catch (_) {}
  };

  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    try {
      getIt<AppLogger>().error(
        'Uncaught asynchronous error',
        error: error,
        stackTrace: stack,
      );
    } on Object catch (_) {}
    return true;
  };

  // Initialize BLoC logging
  Bloc.observer = AppBlocObserver(getIt<AppLogger>());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _GlobalBlocsWidget(
      child: MaterialApp.router(
        title: appConfig.appName,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: getIt<GoRouter>(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          if (appConfig.env == Env.dev) {
            final talkerLogger = AppLoggerRegistry.instance.loggers
                .whereType<TalkerAppLogger>()
                .firstOrNull;

            if (talkerLogger != null) {
              return DevToolsOverlay(
                talkerLogger: talkerLogger,
                options: DevToolsOptions(
                  navigatorKey: rootNavigatorKey,
                  onClearCache: () async {
                    AppLoggerRegistry.instance.warning(
                      'Clear cache is not implemented.',
                    );
                  },
                ),
                child: child!,
              );
            }
          }
          return child!;
        },
      ),
    );
  }
}

class _GlobalBlocsWidget extends StatelessWidget {
  const _GlobalBlocsWidget({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..started(),
          lazy: false,
        ),
      ],
      child: child,
    );
  }
}
