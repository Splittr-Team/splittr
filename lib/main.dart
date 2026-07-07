import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppTheme;
import 'package:sky_devtools/sky_devtools.dart';
import 'package:sky_router/sky_router.dart';
import 'package:sky_storage_hive/sky_storage_hive.dart';
import 'package:sky_telemetry/sky_telemetry.dart';
import 'package:splittr/constants/env/env.dart';
import 'package:splittr/core/app_config/i_app_config.dart';
import 'package:splittr/core/bloc/app_bloc_observer.dart';
import 'package:splittr/core/router/app_router.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/features/quick_split/data/models/quick_split_hive_registerer.dart';
import 'package:splittr/l10n/generated/app_localizations.dart';

Future<void> mainCommon(Env env) async {
  appConfig = IAppConfig.init(env);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: appConfig.firebaseOptions);

  final hiveInit = HiveDatabaseInitializer(
    registerers: [
      QuickSplitHiveRegisterer(), // Add more here as your app grows
    ],
  );
  await hiveInit.initialize();

  configureDependencies(env);

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
                      'Clearing all Hive boxes...',
                    );
                    try {
                      await Hive.deleteFromDisk();
                      AppLoggerRegistry.instance.info(
                        'Hive databases successfully deleted.',
                      );
                    } on Exception catch (e, stackTrace) {
                      AppLoggerRegistry.instance.error(
                        'Failed to clear Hive storage',
                        error: e,
                        stackTrace: stackTrace,
                      );
                    }
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
