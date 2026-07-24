import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/app_config/data/datasources/app_config_local_data_source.dart';
import 'package:splittr/features/app_config/data/models/app_config_isar_model.dart';

@LazySingleton(as: AppConfigLocalDataSource)
final class AppConfigLocalDataSourceImpl implements AppConfigLocalDataSource {
  const AppConfigLocalDataSourceImpl(this._isar);

  final Isar _isar;

  @override
  Future<AppConfigIsarModel?> getCachedConfig() async {
    return _isar.appConfigIsarModels.get(0);
  }

  @override
  Future<void> saveConfig(AppConfigIsarModel model) async {
    await _isar.writeTxn(() async {
      await _isar.appConfigIsarModels.put(model);
    });
  }
}
