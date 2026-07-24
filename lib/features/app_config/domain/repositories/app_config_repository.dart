import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/app_config/domain/entities/app_config.dart';

abstract interface class AppConfigRepository {
  FutureEitherFailure<AppConfig> getAppConfig();
}
