import 'package:splittr/features/expenses/data/models/balances_model.dart';
import 'package:splittr/features/expenses/data/models/create_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/settle_expense_payload.dart';

abstract interface class ExpensesRemoteDataSource {
  Future<ExpenseDetailsModel> createExpense(CreateExpensePayload payload);

  Future<ExpenseDetailsModel> getExpenseDetails(String id);

  Future<ExpenseDetailsModel> settleExpense(SettleExpensePayload payload);

  Future<BalancesModel> getBalances({String? groupId, bool? simplified});
}
