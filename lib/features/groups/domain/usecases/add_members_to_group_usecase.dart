import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class AddMembersToGroupUseCase
    implements UseCase<void, AddMembersToGroupParams> {
  const AddMembersToGroupUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, void>> call(AddMembersToGroupParams params) {
    return _groupsRepository.addMembersToGroup(
      groupId: params.groupId,
      userIds: params.userIds,
    );
  }
}

class AddMembersToGroupParams extends Equatable {
  const AddMembersToGroupParams({
    required this.groupId,
    required this.userIds,
  });

  final String groupId;
  final List<String> userIds;

  @override
  List<Object?> get props => [groupId, userIds];
}
