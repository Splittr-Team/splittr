import 'package:json_annotation/json_annotation.dart';

part 'settle_expense_payload.g.dart';

@JsonSerializable(createFactory: true)
class SettleExpensePayload {
  const SettleExpensePayload({
    required this.amount,
    required this.currency,
    required this.paidBy,
    required this.receivedBy,
    this.groupId,
  });

  factory SettleExpensePayload.fromJson(Map<String, dynamic> json) =>
      _$SettleExpensePayloadFromJson(json);

  final num amount;
  final String currency;
  final String paidBy;
  final String receivedBy;
  final String? groupId;

  Map<String, dynamic> toJson() => _$SettleExpensePayloadToJson(this);
}
