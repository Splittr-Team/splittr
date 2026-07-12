import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  const ExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.currency,
    required this.paidBy,
    required this.createdBy,
    required this.isPayment,
    required this.spentAt,
    this.category,
    this.groupId,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  final String id;
  final String description;
  final num amount;
  final String currency;
  final String paidBy;
  final String createdBy;
  final bool isPayment;
  final DateTime spentAt;
  final String? category;
  final String? groupId;
}
