import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class LeaveGroupUseCase implements UseCase<void, LeaveGroupParams> {
  const LeaveGroupUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, void>> call(LeaveGroupParams params) {
    return _groupsRepository.leaveGroup(
      groupId: params.groupId,
      userId: params.userId,
    );
  }
}

class LeaveGroupParams extends Equatable {
  const LeaveGroupParams({
    required this.groupId,
    required this.userId,
  });

  final String groupId;
  final String userId;

  @override
  List<Object?> get props => [groupId, userId];
}
