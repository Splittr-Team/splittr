import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/expenses/domain/entities/balances.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@lazySingleton
final class GetBalancesUseCase implements UseCase<Balances, GetBalancesParams> {
  const GetBalancesUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Either<Failure, Balances>> call(GetBalancesParams params) {
    return _repository.getBalances(
      groupId: params.groupId,
      simplified: params.simplified,
    );
  }
}

class GetBalancesParams extends Equatable {
  const GetBalancesParams({
    this.groupId,
    this.simplified,
  });

  final String? groupId;
  final bool? simplified;

  @override
  List<Object?> get props => [groupId, simplified];
}
