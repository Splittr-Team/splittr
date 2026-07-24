import 'package:flutter_test/flutter_test.dart';
import 'package:splittr/features/app_config/domain/entities/app_config.dart';
import 'package:splittr/features/app_config/domain/entities/feature_flags.dart';
import 'package:splittr/features/app_config/domain/entities/system_config.dart';

void main() {
  test('AppConfig domain entity instantiation', () {
    const system = SystemConfig(
      appVersion: AppVersionConfig(
        minSupportedVersion: '1.0.0',
        latestVersion: '1.2.0',
        forceUpdate: false,
        updateUrl: UpdateUrl(
          ios: 'https://apple.com',
          android: 'https://play.google.com',
        ),
        updateMessage: 'Update available',
      ),
      maintenance: MaintenanceConfig(
        inMaintenance: false,
        readOnlyMode: false,
        message: 'Under maintenance',
      ),
    );

    const flags = FeatureFlags(
      enableOcrReceiptScan: true,
      enableSettlementReminders: true,
      enableExportPdf: true,
      enableGroupAnalytics: false,
    );

    const appConfig = AppConfig(
      system: system,
      featureFlags: flags,
      configVersion: 'v1.0.0-initial',
    );

    expect(appConfig.system.appVersion.minSupportedVersion, '1.0.0');
    expect(appConfig.featureFlags.enableOcrReceiptScan, isTrue);
  });
}
