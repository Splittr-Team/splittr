import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_flags.freezed.dart';

@freezed
class FeatureFlags with _$FeatureFlags {
  const FeatureFlags({
    required this.enableOcrReceiptScan,
    required this.enableSettlementReminders,
    required this.enableExportPdf,
    required this.enableGroupAnalytics,
  });

  @override
  final bool enableOcrReceiptScan;
  @override
  final bool enableSettlementReminders;
  @override
  final bool enableExportPdf;
  @override
  final bool enableGroupAnalytics;

  static const defaults = FeatureFlags(
    enableOcrReceiptScan: false,
    enableSettlementReminders: false,
    enableExportPdf: false,
    enableGroupAnalytics: false,
  );
}
