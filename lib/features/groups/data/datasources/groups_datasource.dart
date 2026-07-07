import 'package:splittr/features/groups/data/models/groups_model.dart';

abstract interface class GroupsDatasource {
  Future<List<GroupsModel>> fetchGroups();
  Future<GroupsModel> createGroup({
    required String description,
    required String name,
  });
}
