import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/entities/input_split.dart';
import 'package:splittr/features/expenses/domain/entities/split_type.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@lazySingleton
final class CreateExpenseUseCase
    implements UseCase<Expense, CreateExpenseParams> {
  const CreateExpenseUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, Expense>> call(CreateExpenseParams params) {
    return _repository.createExpense(
      description: params.description,
      amount: params.amount,
      currency: params.currency,
      paidBy: params.paidBy,
      splitType: params.splitType,
      splits: params.splits,
      category: params.category,
      groupId: params.groupId,
    );
  }
}

class CreateExpenseParams extends Equatable {
  const CreateExpenseParams({
    required this.description,
    required this.amount,
    required this.currency,
    required this.paidBy,
    required this.splitType,
    required this.splits,
    this.category,
    this.groupId,
  });

  final String description;
  final num amount;
  final String currency;
  final String paidBy;
  final SplitType splitType;
  final List<InputSplit> splits;
  final String? category;
  final String? groupId;

  @override
  List<Object?> get props => [
    description,
    amount,
    currency,
    paidBy,
    splitType,
    splits,
    category,
    groupId,
  ];
}
