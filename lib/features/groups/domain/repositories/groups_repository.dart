import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/domain/entities/groups.dart';

abstract interface class GroupsRepository {
  FutureEitherFailure<Groups> fetchGroups();
  FutureEitherFailure<Groups> createGroup({
    required String description,
    required String name,
  });
}
