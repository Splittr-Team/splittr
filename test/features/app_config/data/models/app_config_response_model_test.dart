import 'package:flutter_test/flutter_test.dart';
import 'package:splittr/features/app_config/data/mappers/app_config_model_to_domain.dart';
import 'package:splittr/features/app_config/data/models/app_config_response_model.dart';

void main() {
  test('AppConfigResponseModel deserializes and maps to domain', () {
    final jsonMap = {
      'success': true,
      'data': {
        'system': {
          'appVersion': {
            'minSupportedVersion': '1.0.0',
            'latestVersion': '1.2.0',
            'forceUpdate': false,
            'updateUrl': {
              'ios': 'https://apple.com',
              'android': 'https://play.google.com',
            },
            'updateMessage': 'New release',
          },
          'maintenance': {
            'inMaintenance': false,
            'readOnlyMode': false,
            'message': 'Maintenance',
            'estimatedEndTime': null,
          },
        },
        'featureFlags': {
          'enableOcrReceiptScan': true,
          'enableSettlementReminders': true,
          'enableExportPdf': true,
          'enableGroupAnalytics': false,
        },
      },
      'meta': {
        'configVersion': 'v1.0.0-initial',
        'serverTime': '2026-07-24T15:26:00Z',
      },
    };

    final model = AppConfigResponseModel.fromJson(jsonMap);
    expect(model.meta?.configVersion, 'v1.0.0-initial');

    final domain = model.toDomain();
    expect(domain.system.appVersion.minSupportedVersion, '1.0.0');
    expect(domain.featureFlags.enableOcrReceiptScan, isTrue);
  });
}
