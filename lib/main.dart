import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppTheme;
import 'package:splittr/constants/env/env.dart';
import 'package:splittr/core/app_config/i_app_config.dart';
import 'package:splittr/core/global/presentation/blocs/global_bloc.dart';
import 'package:splittr/core/global/presentation/ui/global_blocs_widget.dart';
import 'package:splittr/core/route_handler/route_handler.dart';
import 'package:splittr/core/route_handler/route_observer.dart';
import 'package:splittr/di/injection.dart';

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
    return GlobalBlocsWidget(
      child: BlocSelector<GlobalBloc, GlobalState, ThemeMode>(
        selector: (state) => state.store.themeMode,
        builder: (context, themeMode) {
          return MaterialApp(
            title: appConfig.appName,
            debugShowCheckedModeBanner: false,
            initialRoute: RouteId.splash.name,
            onGenerateRoute: RouteHandler.generateRoute,
            themeMode: themeMode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            navigatorObservers: [CustomNavigatorObserver()],
          );
        },
      ),
    );
  }
}
