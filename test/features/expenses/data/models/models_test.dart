import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';

void main() {
  test('should deserialize ExpenseDetailsModel successfully', () {
    const jsonStr = '''
    {
      "expense": {
        "id": "exp-1",
        "description": "Lunch",
        "amount": 30,
        "currency": "USD",
        "category": "Food",
        "groupId": "group-1",
        "paidBy": "user-1",
        "createdBy": "user-1",
        "isPayment": false,
        "spentAt": "2026-07-12T14:00:00Z",
        "createdAt": "2026-07-12T14:00:00Z"
      },
      "splits": [
        {
          "userId": "user-1",
          "amount": 15,
          "splitType": "EQUAL",
          "name": "Alice"
        }
      ]
    }
    ''';

    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    final model = ExpenseDetailsModel.fromJson(map);

    expect(model.expense.id, 'exp-1');
    expect(model.splits.first.name, 'Alice');
  });
}
