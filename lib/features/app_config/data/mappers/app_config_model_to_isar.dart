import 'package:splittr/features/app_config/data/models/app_config_isar_model.dart';
import 'package:splittr/features/app_config/data/models/app_config_response_model.dart';

extension UpdateUrlModelToIsarX on UpdateUrlModel {
  UpdateUrlIsarModel toIsar() {
    return UpdateUrlIsarModel()
      ..ios = ios
      ..android = android;
  }
}

extension AppVersionModelToIsarX on AppVersionModel {
  AppVersionIsarModel toIsar() {
    return AppVersionIsarModel()
      ..minSupportedVersion = minSupportedVersion
      ..latestVersion = latestVersion
      ..forceUpdate = forceUpdate
      ..updateUrl = updateUrl?.toIsar()
      ..updateMessage = updateMessage;
  }
}

extension MaintenanceModelToIsarX on MaintenanceModel {
  MaintenanceIsarModel toIsar() {
    return MaintenanceIsarModel()
      ..inMaintenance = inMaintenance
      ..readOnlyMode = readOnlyMode
      ..message = message
      ..estimatedEndTime = estimatedEndTime;
  }
}

extension SystemConfigModelToIsarX on SystemConfigModel {
  SystemConfigIsarModel toIsar() {
    return SystemConfigIsarModel()
      ..appVersion = appVersion?.toIsar()
      ..maintenance = maintenance?.toIsar();
  }
}

extension CategoryModelToIsarX on CategoryModel {
  CategoryIsarModel toIsar() {
    return CategoryIsarModel()
      ..id = id
      ..name = name
      ..iconUrl = iconUrl;
  }
}

extension CategoryModelListToIsarX on List<CategoryModel> {
  List<CategoryIsarModel> toIsar() => map((c) => c.toIsar()).toList();
}

extension CurrencyModelToIsarX on CurrencyModel {
  CurrencyIsarModel toIsar() {
    return CurrencyIsarModel()
      ..code = code
      ..symbol = symbol
      ..name = name
      ..decimalPlaces = decimalPlaces
      ..isDefault = isDefault;
  }
}

extension CurrencyModelListToIsarX on List<CurrencyModel> {
  List<CurrencyIsarModel> toIsar() => map((c) => c.toIsar()).toList();
}

extension SplitTypeModelToIsarX on SplitTypeModel {
  SplitTypeIsarModel toIsar() {
    return SplitTypeIsarModel()
      ..code = code
      ..label = label
      ..description = description;
  }
}

extension SplitTypeModelListToIsarX on List<SplitTypeModel> {
  List<SplitTypeIsarModel> toIsar() => map((s) => s.toIsar()).toList();
}

extension LimitsModelToIsarX on LimitsModel {
  LimitsIsarModel toIsar() {
    return LimitsIsarModel()
      ..maxExpenseAmount = maxExpenseAmount?.toDouble()
      ..maxGroupMembers = maxGroupMembers
      ..maxSplitParticipants = maxSplitParticipants
      ..maxReceiptSizeMb = maxReceiptSizeMb
      ..allowedReceiptMimeTypes = allowedReceiptMimeTypes;
  }
}

extension PaymentIntegrationModelToIsarX on PaymentIntegrationModel {
  PaymentIntegrationIsarModel toIsar() {
    return PaymentIntegrationIsarModel()
      ..id = id
      ..name = name
      ..enabled = enabled
      ..deepLinkScheme = deepLinkScheme;
  }
}

extension PaymentIntegrationModelListToIsarX on List<PaymentIntegrationModel> {
  List<PaymentIntegrationIsarModel> toIsar() => map((p) => p.toIsar()).toList();
}

extension DomainConfigModelToIsarX on DomainConfigModel {
  DomainConfigIsarModel toIsar() {
    return DomainConfigIsarModel()
      ..categories = categories?.toIsar()
      ..currencies = currencies?.toIsar()
      ..splitTypes = splitTypes?.toIsar()
      ..limits = limits?.toIsar()
      ..paymentIntegrations = paymentIntegrations?.toIsar();
  }
}

extension FeatureFlagsModelToIsarX on FeatureFlagsModel {
  FeatureFlagsIsarModel toIsar() {
    return FeatureFlagsIsarModel()
      ..enableOcrReceiptScan = enableOcrReceiptScan
      ..enableSettlementReminders = enableSettlementReminders
      ..enableExportPdf = enableExportPdf
      ..enableGroupAnalytics = enableGroupAnalytics;
  }
}

extension LegalModelToIsarX on LegalModel {
  LegalIsarModel toIsar() {
    return LegalIsarModel()
      ..termsOfServiceUrl = termsOfServiceUrl
      ..privacyPolicyUrl = privacyPolicyUrl
      ..faqUrl = faqUrl
      ..supportEmail = supportEmail;
  }
}

extension UserContextModelToIsarX on UserContextModel {
  UserContextIsarModel toIsar() {
    return UserContextIsarModel()
      ..isAuthenticated = isAuthenticated
      ..userPreferredCurrency = userPreferredCurrency;
  }
}

extension AppConfigModelToIsarX on AppConfigResponseModel {
  AppConfigIsarModel toIsar({required String etag}) {
    return AppConfigIsarModel()
      ..id = 0
      ..etag = etag
      ..system = data?.system?.toIsar()
      ..domain = data?.domain?.toIsar()
      ..featureFlags = data?.featureFlags?.toIsar()
      ..legal = data?.legal?.toIsar()
      ..userContext = data?.userContext?.toIsar();
  }
}
