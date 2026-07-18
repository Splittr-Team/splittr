part of 'i_app_config.dart';

final class DevAppConfig implements IAppConfig {
  const DevAppConfig._();

  @override
  Env get env => Env.dev;

  @override
  FirebaseOptions get firebaseOptions =>
      firebase_options_dev.DefaultFirebaseOptions.currentPlatform;

  @override
  String get appName => 'Splittr Dev';

  @override
  String get apiBaseUrl => MultiEnv.instance.apiBaseUrl;

  @override
  String get vercelBypassKey => MultiEnv.instance.vercelBypassKey;

  @override
  String get deeplinkBaseUrl => MultiEnv.instance.deeplinkBaseUrl;
}
