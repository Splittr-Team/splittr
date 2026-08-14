import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/expenses/domain/entities/balances.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/entities/input_split.dart';
import 'package:splittr/features/expenses/domain/entities/split_type.dart';

abstract interface class ExpensesRepository {
  Stream<EitherFailure<List<Expense>>> watchExpenses({
    String? groupId,
    bool? personal,
    String? friendId,
  });

  FutureEitherFailure<PaginatedList<Expense>> getExpenses({
    String? cursor,
    int? limit,
    String? groupId,
    bool? personal,
    String? friendId,
  });

  FutureEitherFailure<Expense> createExpense({
    required String description,
    required num amount,
    required String currency,
    required String paidBy,
    required SplitType splitType,
    required List<InputSplit> splits,
    String? category,
    String? groupId,
  });

  FutureEitherFailure<Expense> getExpenseDetails(String id);

  FutureEitherFailureUnit deleteExpense(String id);

  FutureEitherFailure<Expense> settleExpense({
    required num amount,
    required String currency,
    required String paidBy,
    required String receivedBy,
    String? groupId,
  });

  FutureEitherFailure<Balances> getBalances({
    String? groupId,
    bool? simplified,
  });
}
