import 'package:splittr/features/groups/data/models/group_model.dart';
import 'package:splittr/features/groups/data/models/groups_response_model.dart';

abstract interface class GroupsRemoteDataSource {
  Future<GroupsResponseModel> getGroups({
    String? cursor,
    int? limit,
  });

  Future<GroupModel> joinGroup({
    required String inviteCode,
  });

  Future<GroupModel> createGroup({
    required String name,
    required String description,
  });
}
