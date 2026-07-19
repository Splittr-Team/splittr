import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';

abstract interface class GroupsRepository {
  Stream<EitherFailure<List<Group>>> get watchGroups;

  FutureEitherFailure<PaginatedList<Group>> getGroups({
    String? cursor,
    int? limit,
  });

  FutureEitherFailure<Group> joinGroup({
    required String inviteCode,
  });

  FutureEitherFailure<Group> createGroup({
    required String name,
    required String description,
  });

  Future<void> dispose();
}
