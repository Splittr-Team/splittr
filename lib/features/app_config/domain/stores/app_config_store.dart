import 'package:injectable/injectable.dart';
import 'package:splittr/features/app_config/domain/entities/app_config.dart';
import 'package:splittr/features/app_config/domain/entities/domain_config.dart';

@lazySingleton
class AppConfigStore {
  AppConfig? _config;

  AppConfig? get config => _config;

  set config(AppConfig config) {
    _config = config;
  }

  bool get inMaintenance => _config?.system.maintenance.inMaintenance ?? false;

  bool get readOnlyMode => _config?.system.maintenance.readOnlyMode ?? false;

  String get maintenanceMessage => _config?.system.maintenance.message ?? '';

  bool get isForceUpdateRequired =>
      _config?.system.appVersion.forceUpdate ?? false;

  String get updateMessage => _config?.system.appVersion.updateMessage ?? '';

  String get iosUpdateUrl => _config?.system.appVersion.updateUrl.ios ?? '';

  String get androidUpdateUrl =>
      _config?.system.appVersion.updateUrl.android ?? '';

  bool isFeatureEnabled(bool Function(AppConfig config) flagSelector) {
    final config = _config;
    return config != null && flagSelector(config);
  }

  List<CategoryConfig> get categories => _config?.domain?.categories ?? [];

  List<CurrencyConfig> get currencies => _config?.domain?.currencies ?? [];
}
