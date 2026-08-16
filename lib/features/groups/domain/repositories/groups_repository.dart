import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/entities/group_preview.dart';

abstract interface class GroupsRepository {
  Stream<EitherFailure<List<Group>>> get watchGroups;

  FutureEitherFailure<PaginatedList<Group>> getGroups({
    String? cursor,
    int? limit,
  });

  FutureEitherFailure<Group> joinGroup({
    required String inviteCode,
  });

  FutureEitherFailure<GroupPreview> getGroupPreview({
    required String inviteCode,
  });

  FutureEitherFailure<Group> createGroup({
    required String name,
    required String description,
  });

  Future<Either<Failure, void>> deleteGroup({
    required String groupId,
  });

  Future<Either<Failure, void>> addMembersToGroup({
    required String groupId,
    required List<String> userIds,
  });

  Future<Either<Failure, void>> leaveGroup({
    required String groupId,
    required String userId,
  });
}
