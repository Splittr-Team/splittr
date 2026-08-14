import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@lazySingleton
final class WatchExpensesUseCase {
  const WatchExpensesUseCase(this._repository);

  final ExpensesRepository _repository;

  Stream<EitherFailure<List<Expense>>> call({
    String? groupId,
    bool? personal,
    String? friendId,
  }) {
    return _repository.watchExpenses(
      groupId: groupId,
      personal: personal,
      friendId: friendId,
    );
  }
}
