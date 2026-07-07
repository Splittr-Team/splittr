import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/entities/groups.dart';

abstract interface class GroupsRepository {
  Stream<List<Groups>> get watchGroups;
  FutureEitherFailure<List<Groups>> fetchGroups();
  FutureEitherFailure<Groups> createGroup({
    required String description,
    required String name,
  });
  Future<void> dispose();
}
