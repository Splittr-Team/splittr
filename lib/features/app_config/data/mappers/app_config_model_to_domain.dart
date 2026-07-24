import 'package:splittr/features/app_config/data/models/app_config_response_model.dart';
import 'package:splittr/features/app_config/domain/entities/app_config.dart';
import 'package:splittr/features/app_config/domain/entities/domain_config.dart';
import 'package:splittr/features/app_config/domain/entities/feature_flags.dart';
import 'package:splittr/features/app_config/domain/entities/legal_config.dart';
import 'package:splittr/features/app_config/domain/entities/system_config.dart';
import 'package:splittr/features/app_config/domain/entities/user_context.dart';

extension UpdateUrlModelX on UpdateUrlModel {
  UpdateUrl toDomain() => UpdateUrl(
    ios: ios ?? '',
    android: android ?? '',
  );
}

extension AppVersionModelX on AppVersionModel {
  AppVersionConfig toDomain() => AppVersionConfig(
    minSupportedVersion: minSupportedVersion ?? '1.0.0',
    latestVersion: latestVersion ?? '1.0.0',
    forceUpdate: forceUpdate ?? false,
    updateUrl: updateUrl?.toDomain() ?? UpdateUrl.defaults,
    updateMessage: updateMessage ?? '',
  );
}

extension MaintenanceModelX on MaintenanceModel {
  MaintenanceConfig toDomain() => MaintenanceConfig(
    inMaintenance: inMaintenance ?? false,
    readOnlyMode: readOnlyMode ?? false,
    message: message ?? '',
    estimatedEndTime: estimatedEndTime,
  );
}

extension SystemConfigModelX on SystemConfigModel {
  SystemConfig toDomain() => SystemConfig(
    appVersion: appVersion?.toDomain() ?? AppVersionConfig.defaults,
    maintenance: maintenance?.toDomain() ?? MaintenanceConfig.defaults,
  );
}

extension CategoryModelX on CategoryModel {
  CategoryConfig toDomain() => CategoryConfig(
    id: id ?? '',
    name: name ?? '',
    iconUrl: iconUrl ?? '',
  );
}

extension CategoryModelListX on List<CategoryModel> {
  List<CategoryConfig> toDomain() => map((c) => c.toDomain()).toList();
}

extension CurrencyModelX on CurrencyModel {
  CurrencyConfig toDomain() => CurrencyConfig(
    code: code ?? '',
    symbol: symbol ?? '',
    name: name ?? '',
    decimalPlaces: decimalPlaces ?? 2,
    isDefault: isDefault ?? false,
  );
}

extension CurrencyModelListX on List<CurrencyModel> {
  List<CurrencyConfig> toDomain() => map((c) => c.toDomain()).toList();
}

extension SplitTypeModelX on SplitTypeModel {
  SplitTypeConfig toDomain() => SplitTypeConfig(
    code: code ?? '',
    label: label ?? '',
    description: description ?? '',
  );
}

extension SplitTypeModelListX on List<SplitTypeModel> {
  List<SplitTypeConfig> toDomain() => map((s) => s.toDomain()).toList();
}

extension LimitsModelX on LimitsModel {
  LimitsConfig toDomain() => LimitsConfig(
    maxExpenseAmount: maxExpenseAmount ?? 100000.0,
    maxGroupMembers: maxGroupMembers ?? 50,
    maxSplitParticipants: maxSplitParticipants ?? 50,
    maxReceiptSizeMb: maxReceiptSizeMb ?? 10,
    allowedReceiptMimeTypes: allowedReceiptMimeTypes ?? [],
  );
}

extension PaymentIntegrationModelX on PaymentIntegrationModel {
  PaymentIntegrationConfig toDomain() => PaymentIntegrationConfig(
    id: id ?? '',
    name: name ?? '',
    enabled: enabled ?? false,
    deepLinkScheme: deepLinkScheme ?? '',
  );
}

extension PaymentIntegrationModelListX on List<PaymentIntegrationModel> {
  List<PaymentIntegrationConfig> toDomain() =>
      map((p) => p.toDomain()).toList();
}

extension DomainConfigModelX on DomainConfigModel {
  DomainConfig toDomain() => DomainConfig(
    categories: categories?.toDomain() ?? [],
    currencies: currencies?.toDomain() ?? [],
    splitTypes: splitTypes?.toDomain() ?? [],
    limits: limits?.toDomain() ?? LimitsConfig.defaults,
    paymentIntegrations: paymentIntegrations?.toDomain() ?? [],
  );
}

extension FeatureFlagsModelX on FeatureFlagsModel {
  FeatureFlags toDomain() => FeatureFlags(
    enableOcrReceiptScan: enableOcrReceiptScan ?? false,
    enableSettlementReminders: enableSettlementReminders ?? false,
    enableExportPdf: enableExportPdf ?? false,
    enableGroupAnalytics: enableGroupAnalytics ?? false,
  );
}

extension LegalModelX on LegalModel {
  LegalConfig toDomain() => LegalConfig(
    termsOfServiceUrl: termsOfServiceUrl ?? '',
    privacyPolicyUrl: privacyPolicyUrl ?? '',
    faqUrl: faqUrl ?? '',
    supportEmail: supportEmail ?? '',
  );
}

extension UserContextModelX on UserContextModel {
  UserContext toDomain() => UserContext(
    isAuthenticated: isAuthenticated ?? false,
    userPreferredCurrency: userPreferredCurrency,
    userFeatureFlags: userFeatureFlags,
  );
}

extension AppConfigResponseModelX on AppConfigResponseModel {
  AppConfig toDomain() {
    return AppConfig(
      configVersion: meta?.configVersion ?? '',
      system: data?.system?.toDomain() ?? SystemConfig.defaults,
      featureFlags: data?.featureFlags?.toDomain() ?? FeatureFlags.defaults,
      domain: data?.domain?.toDomain(),
      legal: data?.legal?.toDomain(),
      userContext: data?.userContext?.toDomain(),
    );
  }
}
