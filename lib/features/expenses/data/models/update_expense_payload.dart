import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/features/expenses/data/models/input_split_payload.dart';

part 'update_expense_payload.g.dart';

@JsonSerializable()
class UpdateExpensePayload {
  const UpdateExpensePayload({
    this.description,
    this.amount,
    this.currency,
    this.category,
    this.splitType,
    this.splits,
  });

  final String? description;
  final num? amount;
  final String? currency;
  final String? category;
  final String? splitType;
  final List<InputSplitPayload>? splits;

  Map<String, dynamic> toJson() => _$UpdateExpensePayloadToJson(this);
}
