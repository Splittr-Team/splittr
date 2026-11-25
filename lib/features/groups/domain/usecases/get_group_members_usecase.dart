import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class GetGroupMembersUseCase
    implements UseCase<List<Member>, GetGroupMembersParams> {
  const GetGroupMembersUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, List<Member>>> call(GetGroupMembersParams params) {
    return _groupsRepository.getMembers(
      groupId: params.groupId,
      status: params.status,
    );
  }
}

class GetGroupMembersParams extends Equatable {
  const GetGroupMembersParams({
    required this.groupId,
    this.status,
  });

  final String groupId;
  final MemberStatus? status;

  @override
  List<Object?> get props => [groupId, status];
}
