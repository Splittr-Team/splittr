import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class AddMembersUseCase implements UseCase<Unit, AddMembersParams> {
  const AddMembersUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  FutureEitherFailureUnit call(AddMembersParams params) {
    return _groupsRepository.addMembers(
      groupId: params.groupId,
      userIds: params.userIds,
    );
  }
}

class AddMembersParams extends Equatable {
  const AddMembersParams({
    required this.groupId,
    required this.userIds,
  });

  final String groupId;
  final List<String> userIds;

  @override
  List<Object?> get props => [groupId, userIds];
}
