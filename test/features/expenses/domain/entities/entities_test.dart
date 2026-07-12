import 'package:flutter_test/flutter_test.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/entities/split.dart';

void main() {
  test('should create expense and related entities successfully', () {
    const split = Split.equal(
      userId: 'user-1',
      amount: 50,
      name: 'Alice',
    );
    final expense = Expense(
      id: 'exp-1',
      description: 'Dinner',
      amount: 100,
      currency: 'USD',
      category: 'Food',
      paidBy: 'user-1',
      createdBy: 'user-1',
      isPayment: false,
      spentAt: DateTime(2026, 7, 12),
      splits: [split],
    );

    expect(expense.id, 'exp-1');
    expect(expense.splits.first, isA<EqualSplit>());
  });
}
