import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'app_config_isar_model.g.dart';

@Collection()
class AppConfigIsarModel {
  Id id = 0;
  String? etag;
  SystemConfigIsarModel? system;
  DomainConfigIsarModel? domain;
  FeatureFlagsIsarModel? featureFlags;
  LegalIsarModel? legal;
  UserContextIsarModel? userContext;
}

@Embedded()
class SystemConfigIsarModel {
  AppVersionIsarModel? appVersion;
  MaintenanceIsarModel? maintenance;
}

@Embedded()
class AppVersionIsarModel {
  String? minSupportedVersion;
  String? latestVersion;
  bool? forceUpdate;
  UpdateUrlIsarModel? updateUrl;
  String? updateMessage;
}

@Embedded()
class UpdateUrlIsarModel {
  String? ios;
  String? android;
}

@Embedded()
class MaintenanceIsarModel {
  bool? inMaintenance;
  bool? readOnlyMode;
  String? message;
  String? estimatedEndTime;
}

@Embedded()
class DomainConfigIsarModel {
  List<CategoryIsarModel>? categories;
  List<CurrencyIsarModel>? currencies;
  List<SplitTypeIsarModel>? splitTypes;
  LimitsIsarModel? limits;
  List<PaymentIntegrationIsarModel>? paymentIntegrations;
}

@Embedded()
class CategoryIsarModel {
  String? id;
  String? name;
  String? iconUrl;
}

@Embedded()
class CurrencyIsarModel {
  String? code;
  String? symbol;
  String? name;
  int? decimalPlaces;
  bool? isDefault;
}

@Embedded()
class SplitTypeIsarModel {
  String? code;
  String? label;
  String? description;
}

@Embedded()
class LimitsIsarModel {
  double? maxExpenseAmount;
  int? maxGroupMembers;
  int? maxSplitParticipants;
  int? maxReceiptSizeMb;
  List<String>? allowedReceiptMimeTypes;
}

@Embedded()
class PaymentIntegrationIsarModel {
  String? id;
  String? name;
  bool? enabled;
  String? deepLinkScheme;
}

@Embedded()
class FeatureFlagsIsarModel {
  bool? enableOcrReceiptScan;
  bool? enableSettlementReminders;
  bool? enableExportPdf;
  bool? enableGroupAnalytics;
}

@Embedded()
class LegalIsarModel {
  String? termsOfServiceUrl;
  String? privacyPolicyUrl;
  String? faqUrl;
  String? supportEmail;
}

@Embedded()
class UserContextIsarModel {
  bool? isAuthenticated;
  String? userPreferredCurrency;
}
