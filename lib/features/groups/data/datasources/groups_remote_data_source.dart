import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';
import 'package:splittr/features/groups/data/models/group_preview_model.dart';
import 'package:splittr/features/groups/data/models/groups_response_model.dart';
import 'package:splittr/features/groups/data/models/member_model.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';

abstract interface class GroupsRemoteDataSource {
  Future<GroupsResponseModel> getGroups({String? cursor, int? limit});

  Future<GroupModel> getGroupById(String id);

  Future<List<MemberModel>> getMembers(
    String id, {
    MemberStatus? status,
  });

  Future<GroupModel> joinGroup({required String inviteCode});

  Future<GroupPreviewModel> getGroupPreview(String inviteCode);

  Future<GroupModel> createGroup({
    required String name,
    required String description,
    bool? requireAdminApproval,
  });

  Future<Unit> deleteGroup({required String groupId});

  Future<Unit> addMembers({
    required String groupId,
    required List<String> userIds,
  });

  Future<Unit> leaveOrRemoveGroup({
    required String groupId,
    required String userId,
  });

  Future<MemberModel> updateMemberRole({
    required String groupId,
    required String userId,
    required Role role,
  });
}
