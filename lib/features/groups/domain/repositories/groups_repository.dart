import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';

abstract interface class GroupsRepository {
  Stream<EitherFailure<List<Group>>> get watchGroups;

  FutureEitherFailure<List<Group>> getGroups();

  FutureEitherFailure<Group> createGroup({
    required String name,
    required String description,
  });

  Future<void> dispose();
}
