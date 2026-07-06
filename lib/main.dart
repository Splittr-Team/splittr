import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppTheme;
import 'package:sky_router/sky_router.dart';
import 'package:sky_storage_hive/sky_storage_hive.dart';
import 'package:splittr/constants/env/env.dart';
import 'package:splittr/core/app_config/i_app_config.dart';
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
