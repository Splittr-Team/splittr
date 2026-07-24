import 'package:splittr/features/app_config/data/models/app_config_isar_model.dart';
import 'package:splittr/features/app_config/domain/entities/app_config.dart';
import 'package:splittr/features/app_config/domain/entities/domain_config.dart';
import 'package:splittr/features/app_config/domain/entities/feature_flags.dart';
import 'package:splittr/features/app_config/domain/entities/legal_config.dart';
import 'package:splittr/features/app_config/domain/entities/system_config.dart';
import 'package:splittr/features/app_config/domain/entities/user_context.dart';

extension UpdateUrlIsarModelX on UpdateUrlIsarModel {
  UpdateUrl toDomain() => UpdateUrl(
    ios: ios ?? '',
    android: android ?? '',
  );
}

extension AppVersionIsarModelX on AppVersionIsarModel {
  AppVersionConfig toDomain() => AppVersionConfig(
    minSupportedVersion: minSupportedVersion ?? '1.0.0',
    latestVersion: latestVersion ?? '1.0.0',
    forceUpdate: forceUpdate ?? false,
    updateUrl: updateUrl?.toDomain() ?? UpdateUrl.defaults,
    updateMessage: updateMessage ?? '',
  );
}

extension MaintenanceIsarModelX on MaintenanceIsarModel {
  MaintenanceConfig toDomain() => MaintenanceConfig(
    inMaintenance: inMaintenance ?? false,
    readOnlyMode: readOnlyMode ?? false,
    message: message ?? '',
    estimatedEndTime: estimatedEndTime,
  );
}

extension SystemConfigIsarModelX on SystemConfigIsarModel {
  SystemConfig toDomain() => SystemConfig(
    appVersion: appVersion?.toDomain() ?? AppVersionConfig.defaults,
    maintenance: maintenance?.toDomain() ?? MaintenanceConfig.defaults,
  );
}

extension CategoryIsarModelX on CategoryIsarModel {
  CategoryConfig toDomain() => CategoryConfig(
    id: id ?? '',
    name: name ?? '',
    iconUrl: iconUrl ?? '',
  );
}

extension CategoryIsarModelListX on List<CategoryIsarModel> {
  List<CategoryConfig> toDomain() => map((c) => c.toDomain()).toList();
}

extension CurrencyIsarModelX on CurrencyIsarModel {
  CurrencyConfig toDomain() => CurrencyConfig(
    code: code ?? '',
    symbol: symbol ?? '',
    name: name ?? '',
    decimalPlaces: decimalPlaces ?? 2,
    isDefault: isDefault ?? false,
  );
}

extension CurrencyIsarModelListX on List<CurrencyIsarModel> {
  List<CurrencyConfig> toDomain() => map((c) => c.toDomain()).toList();
}

extension SplitTypeIsarModelX on SplitTypeIsarModel {
  SplitTypeConfig toDomain() => SplitTypeConfig(
    code: code ?? '',
    label: label ?? '',
    description: description ?? '',
  );
}

extension SplitTypeIsarModelListX on List<SplitTypeIsarModel> {
  List<SplitTypeConfig> toDomain() => map((s) => s.toDomain()).toList();
}

extension LimitsIsarModelX on LimitsIsarModel {
  LimitsConfig toDomain() => LimitsConfig(
    maxExpenseAmount: maxExpenseAmount ?? 100000.0,
    maxGroupMembers: maxGroupMembers ?? 50,
    maxSplitParticipants: maxSplitParticipants ?? 50,
    maxReceiptSizeMb: maxReceiptSizeMb ?? 10,
    allowedReceiptMimeTypes: allowedReceiptMimeTypes ?? [],
  );
}

extension PaymentIntegrationIsarModelX on PaymentIntegrationIsarModel {
  PaymentIntegrationConfig toDomain() => PaymentIntegrationConfig(
    id: id ?? '',
    name: name ?? '',
    enabled: enabled ?? false,
    deepLinkScheme: deepLinkScheme ?? '',
  );
}

extension PaymentIntegrationIsarModelListX
    on List<PaymentIntegrationIsarModel> {
  List<PaymentIntegrationConfig> toDomain() =>
      map((p) => p.toDomain()).toList();
}

extension DomainConfigIsarModelX on DomainConfigIsarModel {
  DomainConfig toDomain() => DomainConfig(
    categories: categories?.toDomain() ?? [],
    currencies: currencies?.toDomain() ?? [],
    splitTypes: splitTypes?.toDomain() ?? [],
    limits: limits?.toDomain() ?? LimitsConfig.defaults,
    paymentIntegrations: paymentIntegrations?.toDomain() ?? [],
  );
}

extension FeatureFlagsIsarModelX on FeatureFlagsIsarModel {
  FeatureFlags toDomain() => FeatureFlags(
    enableOcrReceiptScan: enableOcrReceiptScan ?? false,
    enableSettlementReminders: enableSettlementReminders ?? false,
    enableExportPdf: enableExportPdf ?? false,
    enableGroupAnalytics: enableGroupAnalytics ?? false,
  );
}

extension LegalIsarModelX on LegalIsarModel {
  LegalConfig toDomain() => LegalConfig(
    termsOfServiceUrl: termsOfServiceUrl ?? '',
    privacyPolicyUrl: privacyPolicyUrl ?? '',
    faqUrl: faqUrl ?? '',
    supportEmail: supportEmail ?? '',
  );
}

extension UserContextIsarModelX on UserContextIsarModel {
  UserContext toDomain() => UserContext(
    isAuthenticated: isAuthenticated ?? false,
    userPreferredCurrency: userPreferredCurrency,
  );
}

extension AppConfigIsarToDomainX on AppConfigIsarModel {
  AppConfig toDomain() {
    return AppConfig(
      configVersion: etag ?? '',
      system: system?.toDomain() ?? SystemConfig.defaults,
      featureFlags: featureFlags?.toDomain() ?? FeatureFlags.defaults,
      domain: domain?.toDomain(),
      legal: legal?.toDomain(),
      userContext: userContext?.toDomain(),
    );
  }
}
