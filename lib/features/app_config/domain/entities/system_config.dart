import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_config.freezed.dart';

@freezed
class AppVersionConfig with _$AppVersionConfig {
  const AppVersionConfig({
    required this.minSupportedVersion,
    required this.latestVersion,
    required this.forceUpdate,
    required this.updateUrl,
    required this.updateMessage,
  });

  @override
  final String minSupportedVersion;
  @override
  final String latestVersion;
  @override
  final bool forceUpdate;
  @override
  final UpdateUrl updateUrl;
  @override
  final String updateMessage;

  static const defaults = AppVersionConfig(
    minSupportedVersion: '1.0.0',
    latestVersion: '1.0.0',
    forceUpdate: false,
    updateUrl: UpdateUrl.defaults,
    updateMessage: '',
  );
}

@freezed
class UpdateUrl with _$UpdateUrl {
  const UpdateUrl({
    required this.ios,
    required this.android,
  });

  @override
  final String ios;
  @override
  final String android;

  static const defaults = UpdateUrl(ios: '', android: '');
}

@freezed
class MaintenanceConfig with _$MaintenanceConfig {
  const MaintenanceConfig({
    required this.inMaintenance,
    required this.readOnlyMode,
    required this.message,
    this.estimatedEndTime,
  });

  @override
  final bool inMaintenance;
  @override
  final bool readOnlyMode;
  @override
  final String message;
  @override
  final String? estimatedEndTime;

  static const defaults = MaintenanceConfig(
    inMaintenance: false,
    readOnlyMode: false,
    message: '',
  );
}

@freezed
class SystemConfig with _$SystemConfig {
  const SystemConfig({
    required this.appVersion,
    required this.maintenance,
  });

  @override
  final AppVersionConfig appVersion;
  @override
  final MaintenanceConfig maintenance;

  static const defaults = SystemConfig(
    appVersion: AppVersionConfig.defaults,
    maintenance: MaintenanceConfig.defaults,
  );
}
