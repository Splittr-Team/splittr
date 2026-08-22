import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class WatchGroupByIdUseCase
    implements StreamUseCase<Group, WatchGroupByIdParams> {
  const WatchGroupByIdUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  StreamEitherFailure<Group> call(WatchGroupByIdParams params) {
    return _groupsRepository.watchGroupById(params.groupId);
  }
}

class WatchGroupByIdParams extends Equatable {
  const WatchGroupByIdParams({required this.groupId});

  final String groupId;

  @override
  List<Object?> get props => [groupId];
}
