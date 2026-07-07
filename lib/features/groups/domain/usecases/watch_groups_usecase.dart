import 'package:injectable/injectable.dart';
import 'package:splittr/features/groups/domain/entities/groups.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class WatchGroupsUseCase {
  const WatchGroupsUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  Stream<List<Group>> call() {
    return _groupsRepository.watchGroups;
  }
}
