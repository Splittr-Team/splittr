import 'package:injectable/injectable.dart';
import 'package:splittr/features/groups/data/datasources/groups_api_client.dart';
import 'package:splittr/features/groups/data/datasources/groups_datasource.dart';
import 'package:splittr/features/groups/data/models/groups_model.dart';

@LazySingleton(as: GroupsDatasource)
final class GroupsDatasourceImpl implements GroupsDatasource {
  const GroupsDatasourceImpl(this._groupsApiClient);
  final GroupsApiClient _groupsApiClient;

  @override
  Future<GroupsModel> createGroup({
    required String description,
    required String name,
  }) {
    // TODO: implement createGroup
    throw UnimplementedError();
  }

  @override
  Future<GroupsModel> fetchGroups() {
    // TODO: implement fetchGroups
    throw UnimplementedError();
  }
}
