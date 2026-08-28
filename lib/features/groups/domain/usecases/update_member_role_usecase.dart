import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class UpdateMemberRoleUseCase
    implements UseCase<Member, UpdateMemberRoleParams> {
  const UpdateMemberRoleUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, Member>> call(UpdateMemberRoleParams params) {
    return _groupsRepository.updateMemberRole(
      groupId: params.groupId,
      userId: params.userId,
      role: params.role,
    );
  }
}

class UpdateMemberRoleParams extends Equatable {
  const UpdateMemberRoleParams({
    required this.groupId,
    required this.userId,
    required this.role,
  });

  final String groupId;
  final String userId;
  final Role role;

  @override
  List<Object?> get props => [groupId, userId, role];
}
