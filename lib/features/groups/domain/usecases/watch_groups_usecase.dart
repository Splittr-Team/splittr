import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class WatchGroupsUseCase implements StreamUseCase<List<Group>, NoParams> {
  const WatchGroupsUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  StreamEitherFailure<List<Group>> call(NoParams params) {
    return _groupsRepository.watchGroups;
  }
}
