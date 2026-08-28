import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_utils/sky_utils.dart';
import 'package:splittr/features/groups/data/datasources/groups_api_client.dart';
import 'package:splittr/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:splittr/features/groups/data/models/add_members_payload.dart';
import 'package:splittr/features/groups/data/models/create_group_payload.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';
import 'package:splittr/features/groups/data/models/group_preview_model.dart';
import 'package:splittr/features/groups/data/models/groups_response_model.dart';
import 'package:splittr/features/groups/data/models/join_group_payload.dart';
import 'package:splittr/features/groups/data/models/member_model.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';

@LazySingleton(as: GroupsRemoteDataSource)
final class GroupsRemoteDataSourceImpl implements GroupsRemoteDataSource {
  const GroupsRemoteDataSourceImpl(this._groupsApiClient);

  final GroupsApiClient _groupsApiClient;

  @override
  Future<GroupsResponseModel> getGroups({
    String? cursor,
    int? limit,
  }) {
    return _groupsApiClient.getGroups(cursor: cursor, limit: limit);
  }

  @override
  Future<GroupModel> getGroupById(String id) {
    return _groupsApiClient.getGroupById(id);
  }

  @override
  Future<List<MemberModel>> getMembers(
    String id, {
    MemberStatus? status,
  }) {
    return _groupsApiClient.getMembers(
      id,
      status: status?.constantCase,
    );
  }

  @override
  Future<GroupModel> createGroup({
    required String name,
    required String description,
    bool? requireAdminApproval,
  }) {
    return _groupsApiClient.createGroup(
      CreateGroupPayload(
        description: description,
        name: name,
        requireAdminApproval: requireAdminApproval,
      ),
    );
  }

  @override
  Future<GroupModel> joinGroup({
    required String inviteCode,
  }) {
    return _groupsApiClient.joinGroup(JoinGroupPayload(inviteCode: inviteCode));
  }

  @override
  Future<Unit> deleteGroup({required String groupId}) async {
    await _groupsApiClient.deleteGroup(groupId);

    return unit;
  }

  @override
  Future<GroupPreviewModel> getGroupPreview(String inviteCode) {
    return _groupsApiClient.getGroupPreview(inviteCode);
  }

  @override
  Future<Unit> addMembers({
    required String groupId,
    required List<String> userIds,
  }) async {
    await _groupsApiClient.addMembers(
      groupId,
      AddMembersPayload(userIds: userIds),
    );
    return unit;
  }

  @override
  Future<Unit> leaveOrRemoveGroup({
    required String groupId,
    required String userId,
  }) async {
    await _groupsApiClient.leaveOrRemoveGroup(groupId, userId);
    return unit;
  }
}
