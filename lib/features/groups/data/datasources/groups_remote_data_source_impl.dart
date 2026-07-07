import 'package:injectable/injectable.dart';
import 'package:splittr/features/groups/data/datasources/groups_api_client.dart';
import 'package:splittr/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:splittr/features/groups/data/models/create_group_model.dart';
import 'package:splittr/features/groups/data/models/groups_model.dart';

@LazySingleton(as: GroupsDatasource)
final class GroupsDatasourceImpl implements GroupsDatasource {
  const GroupsDatasourceImpl(this._groupsApiClient);

  final GroupsApiClient _groupsApiClient;

  @override
  Future<List<GroupModel>> getGroups() {
    return _groupsApiClient.getGroups();
  }

  @override
  Future<GroupModel> createGroup({
    required String name,
    required String description,
  }) {
    return _groupsApiClient.createGroup(
      CreateGroupModel(description: description, name: name),
    );
  }
}
