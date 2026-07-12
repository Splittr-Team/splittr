import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@lazySingleton
final class GetExpenseDetailsUseCase implements UseCase<Expense, String> {
  const GetExpenseDetailsUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, Expense>> call(String params) {
    return _repository.getExpenseDetails(params);
  }
}
