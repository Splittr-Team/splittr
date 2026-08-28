import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/entities/group_preview.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';

abstract interface class GroupsRepository {
  Stream<EitherFailure<List<Group>>> get watchGroups;

  Stream<EitherFailure<Group>> watchGroupById(String id);

  FutureEitherFailure<Group> getGroupById(String id);

  FutureEitherFailure<List<Member>> getMembers({
    required String groupId,
    MemberStatus? status,
  });

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
    bool? requireAdminApproval,
  });

  FutureEitherFailureUnit deleteGroup({
    required String groupId,
  });

  FutureEitherFailureUnit addMembers({
    required String groupId,
    required List<String> userIds,
  });

  FutureEitherFailureUnit leaveOrRemoveGroup({
    required String groupId,
    required String userId,
  });

  FutureEitherFailure<Member> updateMemberRole({
    required String groupId,
    required String userId,
    required Role role,
  });

  FutureEitherFailure<Member> decideJoinRequest({
    required String groupId,
    required String userId,
    required JoinRequestDecision decision,
  });

  FutureEitherFailure<Group> resetInviteCode({
    required String groupId,
  });
}
