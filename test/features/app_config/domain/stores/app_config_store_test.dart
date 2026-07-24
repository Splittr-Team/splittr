import 'package:flutter_test/flutter_test.dart';
import 'package:splittr/features/app_config/domain/entities/app_config.dart';
import 'package:splittr/features/app_config/domain/entities/feature_flags.dart';
import 'package:splittr/features/app_config/domain/entities/system_config.dart';
import 'package:splittr/features/app_config/domain/stores/app_config_store.dart';

void main() {
  test('AppConfigStore synchronous getters evaluate correctly', () {
    final store = AppConfigStore();
    expect(store.config, isNull);
    expect(store.inMaintenance, isFalse);
    expect(store.readOnlyMode, isFalse);
    expect(store.isForceUpdateRequired, isFalse);

    const config = AppConfig(
      system: SystemConfig(
        appVersion: AppVersionConfig(
          minSupportedVersion: '1.0.0',
          latestVersion: '1.2.0',
          forceUpdate: true,
          updateUrl: UpdateUrl(ios: 'a', android: 'b'),
          updateMessage: 'Please update',
        ),
        maintenance: MaintenanceConfig(
          inMaintenance: true,
          readOnlyMode: true,
          message: 'Maintenance in progress',
        ),
      ),
      featureFlags: FeatureFlags(
        enableOcrReceiptScan: true,
        enableSettlementReminders: false,
        enableExportPdf: true,
        enableGroupAnalytics: false,
      ),
      configVersion: 'v1.0.0-initial',
    );

    store.config = config;

    expect(store.inMaintenance, isTrue);
    expect(store.readOnlyMode, isTrue);
    expect(store.isForceUpdateRequired, isTrue);
    expect(
      store.isFeatureEnabled((c) => c.featureFlags.enableOcrReceiptScan),
      isTrue,
    );
    expect(
      store.isFeatureEnabled((c) => c.featureFlags.enableSettlementReminders),
      isFalse,
    );
  });
}
