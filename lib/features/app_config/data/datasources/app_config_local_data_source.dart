import 'package:splittr/features/app_config/data/models/app_config_isar_model.dart';

abstract interface class AppConfigLocalDataSource {
  Future<AppConfigIsarModel?> getCachedConfig();

  Future<void> saveConfig(AppConfigIsarModel model);
}
