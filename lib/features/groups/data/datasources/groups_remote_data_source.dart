import 'package:splittr/features/groups/data/models/groups_model.dart';

abstract interface class GroupsDatasource {
  Future<List<GroupModel>> getGroups();

  Future<GroupModel> createGroup({
    required String name,
    required String description,
  });
}
