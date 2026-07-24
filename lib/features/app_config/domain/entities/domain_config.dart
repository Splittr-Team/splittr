import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain_config.freezed.dart';

@freezed
class CategoryConfig with _$CategoryConfig {
  const CategoryConfig({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String iconUrl;
}

@freezed
class CurrencyConfig with _$CurrencyConfig {
  const CurrencyConfig({
    required this.code,
    required this.symbol,
    required this.name,
    required this.decimalPlaces,
    required this.isDefault,
  });

  @override
  final String code;
  @override
  final String symbol;
  @override
  final String name;
  @override
  final int decimalPlaces;
  @override
  final bool isDefault;
}

@freezed
class SplitTypeConfig with _$SplitTypeConfig {
  const SplitTypeConfig({
    required this.code,
    required this.label,
    required this.description,
  });

  @override
  final String code;
  @override
  final String label;
  @override
  final String description;
}

@freezed
class LimitsConfig with _$LimitsConfig {
  const LimitsConfig({
    required this.maxExpenseAmount,
    required this.maxGroupMembers,
    required this.maxSplitParticipants,
    required this.maxReceiptSizeMb,
    required this.allowedReceiptMimeTypes,
  });

  @override
  final num maxExpenseAmount;
  @override
  final int maxGroupMembers;
  @override
  final int maxSplitParticipants;
  @override
  final int maxReceiptSizeMb;
  @override
  final List<String> allowedReceiptMimeTypes;

  static const defaults = LimitsConfig(
    maxExpenseAmount: 100000,
    maxGroupMembers: 50,
    maxSplitParticipants: 50,
    maxReceiptSizeMb: 10,
    allowedReceiptMimeTypes: [],
  );
}

@freezed
class PaymentIntegrationConfig with _$PaymentIntegrationConfig {
  const PaymentIntegrationConfig({
    required this.id,
    required this.name,
    required this.enabled,
    required this.deepLinkScheme,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final bool enabled;
  @override
  final String deepLinkScheme;
}

@freezed
class DomainConfig with _$DomainConfig {
  const DomainConfig({
    required this.categories,
    required this.currencies,
    required this.splitTypes,
    required this.limits,
    required this.paymentIntegrations,
  });

  @override
  final List<CategoryConfig> categories;
  @override
  final List<CurrencyConfig> currencies;
  @override
  final List<SplitTypeConfig> splitTypes;
  @override
  final LimitsConfig limits;
  @override
  final List<PaymentIntegrationConfig> paymentIntegrations;
}
