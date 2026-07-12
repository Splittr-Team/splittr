import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@lazySingleton
final class SettleExpenseUseCase
    implements UseCase<Expense, SettleExpenseParams> {
  const SettleExpenseUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, Expense>> call(SettleExpenseParams params) {
    return _repository.settleExpense(
      amount: params.amount,
      currency: params.currency,
      groupId: params.groupId,
      paidBy: params.paidBy,
      receivedBy: params.receivedBy,
    );
  }
}

class SettleExpenseParams extends Equatable {
  const SettleExpenseParams({
    required this.amount,
    required this.currency,
    required this.paidBy,
    required this.receivedBy,
    this.groupId,
  });

  final num amount;
  final String currency;
  final String paidBy;
  final String receivedBy;
  final String? groupId;

  @override
  List<Object?> get props => [
    amount,
    currency,
    paidBy,
    receivedBy,
    groupId,
  ];
}
