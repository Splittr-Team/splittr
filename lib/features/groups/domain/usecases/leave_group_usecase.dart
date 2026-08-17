import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class LeaveOrRemoveGroupUseCase
    implements UseCase<Unit, LeaveOrRemoveGroupParams> {
  const LeaveOrRemoveGroupUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  FutureEitherFailureUnit call(LeaveOrRemoveGroupParams params) {
    return _groupsRepository.leaveOrRemoveGroup(
      groupId: params.groupId,
      userId: params.userId,
    );
  }
}

class LeaveOrRemoveGroupParams extends Equatable {
  const LeaveOrRemoveGroupParams({
    required this.groupId,
    required this.userId,
  });

  final String groupId;
  final String userId;

  @override
  List<Object?> get props => [groupId, userId];
}
