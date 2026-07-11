import 'package:splittr/features/groups/data/models/group_model.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';

extension GroupModelX on GroupModel {
  Group toDomain() => Group(
    id: id,
    name: name,
    description: description,
    inviteCode: inviteCode,
    createdBy: createdBy,
  );
}

extension GroupModelListX on List<GroupModel> {
  List<Group> toDomain() => map((e) => e.toDomain()).toList();
}
