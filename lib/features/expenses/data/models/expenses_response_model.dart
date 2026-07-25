import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/core/network/pagination_model.dart';
import 'package:splittr/features/expenses/data/models/expense_model.dart';

part 'expenses_response_model.g.dart';

@JsonSerializable()
class ExpensesResponseModel {
  const ExpensesResponseModel({
    required this.data,
    required this.pagination,
  });

  factory ExpensesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpensesResponseModelFromJson(json);

  final List<ExpenseModel> data;
  final PaginationModel pagination;
}
