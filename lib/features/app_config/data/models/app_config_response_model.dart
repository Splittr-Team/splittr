import 'package:json_annotation/json_annotation.dart';

part 'app_config_response_model.g.dart';

@JsonSerializable()
class AppConfigResponseModel {
  const AppConfigResponseModel({
    this.success,
    this.data,
    this.meta,
  });

  factory AppConfigResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigResponseModelFromJson(json);

  final bool? success;
  final AppConfigDataModel? data;
  final AppConfigMetaModel? meta;
}

@JsonSerializable()
class AppConfigDataModel {
  const AppConfigDataModel({
    this.system,
    this.domain,
    this.featureFlags,
    this.legal,
    this.userContext,
  });

  factory AppConfigDataModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigDataModelFromJson(json);

  final SystemConfigModel? system;
  final DomainConfigModel? domain;
  final FeatureFlagsModel? featureFlags;
  final LegalModel? legal;
  final UserContextModel? userContext;
}

@JsonSerializable()
class SystemConfigModel {
  const SystemConfigModel({this.appVersion, this.maintenance});

  factory SystemConfigModel.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigModelFromJson(json);

  final AppVersionModel? appVersion;
  final MaintenanceModel? maintenance;
}

@JsonSerializable()
class AppVersionModel {
  const AppVersionModel({
    this.minSupportedVersion,
    this.latestVersion,
    this.forceUpdate,
    this.updateUrl,
    this.updateMessage,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) =>
      _$AppVersionModelFromJson(json);

  final String? minSupportedVersion;
  final String? latestVersion;
  final bool? forceUpdate;
  final UpdateUrlModel? updateUrl;
  final String? updateMessage;
}

@JsonSerializable()
class UpdateUrlModel {
  const UpdateUrlModel({this.ios, this.android});

  factory UpdateUrlModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateUrlModelFromJson(json);

  final String? ios;
  final String? android;
}

@JsonSerializable()
class MaintenanceModel {
  const MaintenanceModel({
    this.inMaintenance,
    this.readOnlyMode,
    this.message,
    this.estimatedEndTime,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceModelFromJson(json);

  final bool? inMaintenance;
  final bool? readOnlyMode;
  final String? message;
  final String? estimatedEndTime;
}

@JsonSerializable()
class DomainConfigModel {
  const DomainConfigModel({
    this.categories,
    this.currencies,
    this.splitTypes,
    this.limits,
    this.paymentIntegrations,
  });

  factory DomainConfigModel.fromJson(Map<String, dynamic> json) =>
      _$DomainConfigModelFromJson(json);

  final List<CategoryModel>? categories;
  final List<CurrencyModel>? currencies;
  final List<SplitTypeModel>? splitTypes;
  final LimitsModel? limits;
  final List<PaymentIntegrationModel>? paymentIntegrations;
}

@JsonSerializable()
class CategoryModel {
  const CategoryModel({this.id, this.name, this.iconUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  final String? id;
  final String? name;
  final String? iconUrl;
}

@JsonSerializable()
class CurrencyModel {
  const CurrencyModel({
    this.code,
    this.symbol,
    this.name,
    this.decimalPlaces,
    this.isDefault,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  final String? code;
  final String? symbol;
  final String? name;
  final int? decimalPlaces;
  final bool? isDefault;
}

@JsonSerializable()
class SplitTypeModel {
  const SplitTypeModel({this.code, this.label, this.description});

  factory SplitTypeModel.fromJson(Map<String, dynamic> json) =>
      _$SplitTypeModelFromJson(json);

  final String? code;
  final String? label;
  final String? description;
}

@JsonSerializable()
class LimitsModel {
  const LimitsModel({
    this.maxExpenseAmount,
    this.maxGroupMembers,
    this.maxSplitParticipants,
    this.maxReceiptSizeMb,
    this.allowedReceiptMimeTypes,
  });

  factory LimitsModel.fromJson(Map<String, dynamic> json) =>
      _$LimitsModelFromJson(json);

  final num? maxExpenseAmount;
  final int? maxGroupMembers;
  final int? maxSplitParticipants;
  final int? maxReceiptSizeMb;
  final List<String>? allowedReceiptMimeTypes;
}

@JsonSerializable()
class PaymentIntegrationModel {
  const PaymentIntegrationModel({
    this.id,
    this.name,
    this.enabled,
    this.deepLinkScheme,
  });

  factory PaymentIntegrationModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntegrationModelFromJson(json);

  final String? id;
  final String? name;
  final bool? enabled;
  final String? deepLinkScheme;
}

@JsonSerializable()
class FeatureFlagsModel {
  const FeatureFlagsModel({
    this.enableOcrReceiptScan,
    this.enableSettlementReminders,
    this.enableExportPdf,
    this.enableGroupAnalytics,
  });

  factory FeatureFlagsModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagsModelFromJson(json);

  final bool? enableOcrReceiptScan;
  final bool? enableSettlementReminders;
  final bool? enableExportPdf;
  final bool? enableGroupAnalytics;
}

@JsonSerializable()
class LegalModel {
  const LegalModel({
    this.termsOfServiceUrl,
    this.privacyPolicyUrl,
    this.faqUrl,
    this.supportEmail,
  });

  factory LegalModel.fromJson(Map<String, dynamic> json) =>
      _$LegalModelFromJson(json);

  final String? termsOfServiceUrl;
  final String? privacyPolicyUrl;
  final String? faqUrl;
  final String? supportEmail;
}

@JsonSerializable()
class UserContextModel {
  const UserContextModel({
    this.isAuthenticated,
    this.userPreferredCurrency,
    this.userFeatureFlags,
  });

  factory UserContextModel.fromJson(Map<String, dynamic> json) =>
      _$UserContextModelFromJson(json);

  final bool? isAuthenticated;
  final String? userPreferredCurrency;
  final Map<String, dynamic>? userFeatureFlags;
}

@JsonSerializable()
class AppConfigMetaModel {
  const AppConfigMetaModel({this.configVersion, this.serverTime});

  factory AppConfigMetaModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigMetaModelFromJson(json);

  final String? configVersion;
  final String? serverTime;
}
