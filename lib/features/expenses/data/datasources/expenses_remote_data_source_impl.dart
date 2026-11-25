import 'package:injectable/injectable.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_api_client.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:splittr/features/expenses/data/models/balances_model.dart';
import 'package:splittr/features/expenses/data/models/create_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/expenses_response_model.dart';
import 'package:splittr/features/expenses/data/models/settle_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/update_expense_payload.dart';

@LazySingleton(as: ExpensesRemoteDataSource)
final class ExpensesRemoteDataSourceImpl implements ExpensesRemoteDataSource {
  const ExpensesRemoteDataSourceImpl(this._apiClient);

  final ExpensesApiClient _apiClient;

  @override
  Future<ExpensesResponseModel> getExpenses({
    String? cursor,
    int? limit,
    String? groupId,
    bool? personal,
    String? friendId,
  }) {
    return _apiClient.getExpenses(
      cursor: cursor,
      limit: limit,
      groupId: groupId,
      personal: personal,
      friendId: friendId,
    );
  }

  @override
  Future<ExpenseDetailsModel> createExpense(CreateExpensePayload payload) {
    return _apiClient.createExpense(payload);
  }

  @override
  Future<ExpenseDetailsModel> getExpenseDetails(String id) {
    return _apiClient.getExpenseDetails(id);
  }

  @override
  Future<ExpenseDetailsModel> updateExpense(
    String id,
    UpdateExpensePayload payload,
  ) {
    return _apiClient.updateExpense(id, payload);
  }

  @override
  Future<ExpenseDetailsModel> settleExpense(SettleExpensePayload payload) {
    return _apiClient.settleExpense(payload);
  }

  @override
  Future<void> deleteExpense(String id) {
    return _apiClient.deleteExpense(id);
  }

  @override
  Future<BalancesModel> getBalances({String? groupId, bool? simplified}) {
    return _apiClient.getBalances(groupId: groupId, simplified: simplified);
  }
}
