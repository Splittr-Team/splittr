import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';
import 'package:splittr/features/groups/data/models/group_preview_model.dart';
import 'package:splittr/features/groups/data/models/groups_response_model.dart';

abstract interface class GroupsRemoteDataSource {
  Future<GroupsResponseModel> getGroups({String? cursor, int? limit});

  Future<GroupModel> joinGroup({required String inviteCode});

  Future<GroupPreviewModel> getGroupPreview(String inviteCode);

  Future<GroupModel> createGroup({
    required String name,
    required String description,
  });

  Future<Unit> deleteGroup({required String groupId});

  Future<Unit> addMembersToGroup({
    required String groupId,
    required List<String> userIds,
  });

  Future<Unit> leaveGroup({
    required String groupId,
    required String userId,
  });
}
