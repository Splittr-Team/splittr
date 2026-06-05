import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppTheme;
import 'package:splittr/constants/env/env.dart';
import 'package:splittr/core/app_config/i_app_config.dart';
import 'package:splittr/core/route_handler/route_handler.dart';
import 'package:splittr/core/route_handler/route_observer.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';

Future<void> mainCommon(Env env) async {
  appConfig = IAppConfig.init(env);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: appConfig.firebaseOptions);

  configureDependencies(env);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _GlobalBlocsWidget(
      child: MaterialApp(
        title: appConfig.appName,
        debugShowCheckedModeBanner: false,
        initialRoute: RouteId.splash.name,
        onGenerateRoute: RouteHandler.generateRoute,
        themeMode: ThemeMode.dark,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        navigatorObservers: [CustomNavigatorObserver()],
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
        BlocProvider(create: (_) => getIt<AuthBloc>()),
      ],
      child: child,
    );
  }
}
