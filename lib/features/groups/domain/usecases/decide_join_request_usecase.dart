import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class DecideJoinRequestUseCase
    implements UseCase<Member, DecideJoinRequestParams> {
  const DecideJoinRequestUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, Member>> call(DecideJoinRequestParams params) {
    return _groupsRepository.decideJoinRequest(
      groupId: params.groupId,
      userId: params.userId,
      decision: params.decision,
    );
  }
}

class DecideJoinRequestParams extends Equatable {
  const DecideJoinRequestParams({
    required this.groupId,
    required this.userId,
    required this.decision,
  });

  final String groupId;
  final String userId;
  final JoinRequestDecision decision;

  @override
  List<Object?> get props => [groupId, userId, decision];
}
