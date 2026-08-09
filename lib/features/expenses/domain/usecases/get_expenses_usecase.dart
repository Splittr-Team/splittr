import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@lazySingleton
final class GetExpensesUseCase
    implements UseCase<PaginatedList<Expense>, GetExpensesParams> {
  const GetExpensesUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, PaginatedList<Expense>>> call(
    GetExpensesParams params,
  ) {
    return _repository.getExpenses(
      cursor: params.cursor,
      limit: params.limit,
      groupId: params.groupId,
      personal: params.personal,
      friendId: params.friendId,
    );
  }
}

class GetExpensesParams extends Equatable {
  const GetExpensesParams({
    this.cursor,
    this.limit,
    this.groupId,
    this.personal,
    this.friendId,
  });

  final String? cursor;
  final int? limit;
  final String? groupId;
  final bool? personal;
  final String? friendId;

  @override
  List<Object?> get props => [cursor, limit, groupId, personal, friendId];
}
