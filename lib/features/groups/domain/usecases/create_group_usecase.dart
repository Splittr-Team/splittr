import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class CreateGroupUseCase implements UseCase<Group, CreateGroupParams> {
  const CreateGroupUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, Group>> call(CreateGroupParams params) {
    return _groupsRepository.createGroup(
      description: params.description,
      name: params.name,
    );
  }
}

class CreateGroupParams extends Equatable {
  const CreateGroupParams({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  @override
  List<Object?> get props => [name, description];
}
