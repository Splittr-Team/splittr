import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@lazySingleton
final class DeleteExpenseUseCase implements UseCase<Unit, DeleteExpenseParams> {
  const DeleteExpenseUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteExpenseParams params) {
    return _repository.deleteExpense(params.id);
  }
}

class DeleteExpenseParams extends Equatable {
  const DeleteExpenseParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
