import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class GetGroupByIdUseCase implements UseCase<Group, GetGroupByIdParams> {
  const GetGroupByIdUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, Group>> call(GetGroupByIdParams params) {
    return _groupsRepository.getGroupById(params.groupId);
  }
}

class GetGroupByIdParams extends Equatable {
  const GetGroupByIdParams({required this.groupId});

  final String groupId;

  @override
  List<Object?> get props => [groupId];
}
