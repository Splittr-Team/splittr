import 'package:splittr/features/expenses/data/models/balances_model.dart';
import 'package:splittr/features/expenses/data/models/create_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/expenses_response_model.dart';
import 'package:splittr/features/expenses/data/models/settle_expense_payload.dart';

abstract interface class ExpensesRemoteDataSource {
  Future<ExpensesResponseModel> getExpenses({
    String? cursor,
    int? limit,
    String? groupId,
    bool? personal,
    String? friendId,
  });

  Future<ExpenseDetailsModel> createExpense(CreateExpensePayload payload);

  Future<ExpenseDetailsModel> getExpenseDetails(String id);

  Future<ExpenseDetailsModel> settleExpense(SettleExpensePayload payload);

  Future<void> deleteExpense(String id);

  Future<BalancesModel> getBalances({String? groupId, bool? simplified});
}
