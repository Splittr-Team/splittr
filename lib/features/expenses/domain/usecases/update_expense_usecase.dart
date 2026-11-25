import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/entities/input_split.dart';
import 'package:splittr/features/expenses/domain/entities/split_type.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@lazySingleton
final class UpdateExpenseUseCase
    implements UseCase<Expense, UpdateExpenseParams> {
  const UpdateExpenseUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, Expense>> call(UpdateExpenseParams params) {
    return _repository.updateExpense(
      id: params.id,
      description: params.description,
      amount: params.amount,
      currency: params.currency,
      category: params.category,
      splitType: params.splitType,
      splits: params.splits,
    );
  }
}

class UpdateExpenseParams extends Equatable {
  const UpdateExpenseParams({
    required this.id,
    this.description,
    this.amount,
    this.currency,
    this.category,
    this.splitType,
    this.splits,
  });

  final String id;
  final String? description;
  final num? amount;
  final String? currency;
  final String? category;
  final SplitType? splitType;
  final List<InputSplit>? splits;

  @override
  List<Object?> get props => [
    id,
    description,
    amount,
    currency,
    category,
    splitType,
    splits,
  ];
}
