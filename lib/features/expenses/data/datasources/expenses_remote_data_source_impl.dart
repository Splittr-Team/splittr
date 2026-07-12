import 'package:injectable/injectable.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_api_client.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:splittr/features/expenses/data/models/balances_model.dart';
import 'package:splittr/features/expenses/data/models/create_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/settle_expense_payload.dart';

@LazySingleton(as: ExpensesRemoteDataSource)
final class ExpensesRemoteDataSourceImpl implements ExpensesRemoteDataSource {
  const ExpensesRemoteDataSourceImpl(this._apiClient);

  final ExpensesApiClient _apiClient;

  @override
  Future<ExpenseDetailsModel> createExpense(CreateExpensePayload payload) {
    return _apiClient.createExpense(payload);
  }

  @override
  Future<ExpenseDetailsModel> getExpenseDetails(String id) {
    return _apiClient.getExpenseDetails(id);
  }

  @override
  Future<ExpenseDetailsModel> settleExpense(SettleExpensePayload payload) {
    return _apiClient.settleExpense(payload);
  }

  @override
  Future<BalancesModel> getBalances({String? groupId, bool? simplified}) {
    return _apiClient.getBalances(groupId: groupId, simplified: simplified);
  }
}
