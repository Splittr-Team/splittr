import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splittr/features/expenses/domain/entities/split.dart';

part 'expense.freezed.dart';

@freezed
class Expense with _$Expense {
  const Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.currency,
    required this.paidBy,
    required this.createdBy,
    required this.isPayment,
    required this.spentAt,
    required this.splits,
    this.category,
    this.groupId,
  });

  @override
  final String id;
  @override
  final String description;
  @override
  final num amount;
  @override
  final String currency;
  @override
  final String paidBy;
  @override
  final String createdBy;
  @override
  final bool isPayment;
  @override
  final DateTime spentAt;
  @override
  final List<Split> splits;
  @override
  final String? category;
  @override
  final String? groupId;
}
