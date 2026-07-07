import 'package:fpdart/fpdart.dart' hide Group;
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

// TODO(Chaitanya): make it equatable
@lazySingleton
final class CreateGroupsUseCase implements UseCase<Group, CreateGroupParams> {
  const CreateGroupsUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, Group>> call(CreateGroupParams params) {
    return _groupsRepository.createGroup(
      description: params.description,
      name: params.name,
    );
  }
}

class CreateGroupParams {
  const CreateGroupParams({
    required this.name,
    required this.description,
  });
  final String name;
  final String description;
}
