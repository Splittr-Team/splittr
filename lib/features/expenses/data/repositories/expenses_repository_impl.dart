import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:sky_utils/sky_utils.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:splittr/features/expenses/data/mappers/expense_mappers.dart';
import 'package:splittr/features/expenses/data/models/create_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/settle_expense_payload.dart';
import 'package:splittr/features/expenses/domain/entities/balances.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/entities/input_split.dart';
import 'package:splittr/features/expenses/domain/entities/split_type.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@LazySingleton(as: ExpensesRepository)
final class ExpensesRepositoryImpl implements ExpensesRepository {
  const ExpensesRepositoryImpl(this._apiCallHandler, this._dataSource);

  final ApiCallHandler _apiCallHandler;
  final ExpensesRemoteDataSource _dataSource;

  @override
  FutureEitherFailure<Expense> createExpense({
    required String description,
    required num amount,
    required String currency,
    required String paidBy,
    required SplitType splitType,
    required List<InputSplit> splits,
    String? category,
    String? groupId,
  }) async {
    final result = await _apiCallHandler.handle(
          () => _dataSource.createExpense(
        CreateExpensePayload(
          description: description,
          amount: amount,
          currency: currency,
          paidBy: paidBy,
          splitType: splitType.constantCase,
          splits: splits.toModel(),
          category: category,
          groupId: groupId,
        ),
      ),
    );
    return result.map((details) => details.toDomain());
  }

  @override
  FutureEitherFailure<Expense> getExpenseDetails(String id) async {
    final result = await _apiCallHandler.handle(
      () => _dataSource.getExpenseDetails(id),
    );
    return result.map((details) => details.toDomain());
  }

  @override
  FutureEitherFailure<Expense> settleExpense({
    required num amount,
    required String currency,
    required String paidBy,
    required String receivedBy,
    String? groupId,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _dataSource.settleExpense(
        SettleExpensePayload(
          amount: amount,
          currency: currency,
          paidBy: paidBy,
          receivedBy: receivedBy,
          groupId: groupId,
        ),
      ),
    );
    return result.map((details) => details.toDomain());
  }

  @override
  FutureEitherFailure<Balances> getBalances({
    String? groupId,
    bool? simplified,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _dataSource.getBalances(groupId: groupId, simplified: simplified),
    );
    return result.map((balancesModel) => balancesModel.toDomain());
  }
}
