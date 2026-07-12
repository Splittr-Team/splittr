import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/features/expenses/data/models/input_split_payload.dart';

part 'create_expense_payload.g.dart';

@JsonSerializable()
class CreateExpensePayload {
  const CreateExpensePayload({
    required this.amount,
    required this.description,
    required this.currency,
    required this.paidBy,
    required this.splitType,
    required this.splits,
    this.category,
    this.groupId,
  });

  final num amount;
  final String description;
  final String currency;
  final String paidBy;
  final String splitType;
  final List<InputSplitPayload> splits;
  final String? category;
  final String? groupId;

  Map<String, dynamic> toJson() => _$CreateExpensePayloadToJson(this);
}
