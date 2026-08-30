import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class UpdateGroupUseCase implements UseCase<Group, UpdateGroupParams> {
  const UpdateGroupUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, Group>> call(UpdateGroupParams params) {
    return _groupsRepository.updateGroup(
      groupId: params.groupId,
      name: params.name,
      description: params.description,
      requireAdminApproval: params.requireAdminApproval,
    );
  }
}

class UpdateGroupParams extends Equatable {
  const UpdateGroupParams({
    required this.groupId,
    this.name,
    this.description,
    this.requireAdminApproval,
  });

  final String groupId;
  final String? name;
  final String? description;
  final bool? requireAdminApproval;

  @override
  List<Object?> get props => [groupId, name, description, requireAdminApproval];
}
