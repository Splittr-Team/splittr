import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class ResetInviteCodeUseCase
    implements UseCase<Group, ResetInviteCodeParams> {
  const ResetInviteCodeUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, Group>> call(ResetInviteCodeParams params) {
    return _groupsRepository.resetInviteCode(
      groupId: params.groupId,
    );
  }
}

class ResetInviteCodeParams extends Equatable {
  const ResetInviteCodeParams({
    required this.groupId,
  });

  final String groupId;

  @override
  List<Object?> get props => [groupId];
}
