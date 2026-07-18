import 'package:firebase_core/firebase_core.dart';
import 'package:splittr/constants/env/env.dart';
import 'package:splittr/core/app_config/env/multi_env.dart';
import 'package:splittr/core/firebase/firebase_options_dev.dart'
    as firebase_options_dev;
import 'package:splittr/core/firebase/firebase_options_prod.dart'
    as firebase_options_prod;

part 'dev_app_config.dart';
part 'prod_app_config.dart';

late final IAppConfig appConfig;

abstract interface class IAppConfig {
  factory IAppConfig.init(Env env) {
    MultiEnv.init(env);

    return switch (env) {
      Env.dev => const DevAppConfig._(),
      Env.prod => const ProdAppConfig._(),
    };
  }

  Env get env;

  FirebaseOptions get firebaseOptions;

  String get appName;

  String get apiBaseUrl;

  String get vercelBypassKey;

  String get deeplinkBaseUrl;
}
