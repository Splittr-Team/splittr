import 'package:flutter_test/flutter_test.dart';
import 'package:splittr/features/expenses/data/mappers/expense_mappers.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/expense_model.dart';
import 'package:splittr/features/expenses/data/models/split_model.dart';
import 'package:splittr/features/expenses/domain/entities/split.dart';

void main() {
  test('should map ExpenseDetailsModel to Expense entity correctly', () {
    final detailsModel = ExpenseDetailsModel(
      expense: ExpenseModel(
        id: 'exp-1',
        description: 'Coffee',
        amount: 6,
        currency: 'USD',
        category: 'Food',
        paidBy: 'user-1',
        createdBy: 'user-1',
        isPayment: false,
        spentAt: DateTime(2026, 7, 12),
      ),
      splits: [
        const SplitModel(
          userId: 'user-1',
          amount: 6,
          splitType: 'PERCENTAGE',
          splitValue: 100,
          name: 'Alice',
        ),
      ],
    );

    final entity = detailsModel.toDomain();

    expect(entity.id, 'exp-1');
    expect(entity.splits.first, isA<PercentageSplit>());
    expect((entity.splits.first as PercentageSplit).splitValue, 100);
  });
}
