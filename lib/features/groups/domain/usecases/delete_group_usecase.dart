import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class DeleteGroupUseCase implements UseCase<Unit, DeleteGroupParams> {
  const DeleteGroupUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, Unit>> call(DeleteGroupParams params) {
    return _groupsRepository.deleteGroup(groupId: params.groupId);
  }
}

class DeleteGroupParams extends Equatable {
  const DeleteGroupParams({required this.groupId});

  final String groupId;

  @override
  List<Object?> get props => [groupId];
}
