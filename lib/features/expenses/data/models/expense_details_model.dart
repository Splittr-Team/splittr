import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/features/expenses/data/models/expense_model.dart';
import 'package:splittr/features/expenses/data/models/split_model.dart';

part 'expense_details_model.g.dart';

@JsonSerializable()
class ExpenseDetailsModel {
  const ExpenseDetailsModel({
    required this.expense,
    required this.splits,
  });

  factory ExpenseDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDetailsModelFromJson(json);

  final ExpenseModel expense;
  final List<SplitModel> splits;
}
