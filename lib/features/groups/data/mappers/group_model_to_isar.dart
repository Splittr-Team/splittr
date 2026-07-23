import 'package:splittr/features/groups/data/models/group_isar_model.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';
import 'package:splittr/features/groups/data/models/member_model.dart';

extension GroupModelX on GroupModel {
  GroupIsarModel toIsar() => GroupIsarModel()
    ..id = id
    ..name = name
    ..description = description
    ..inviteCode = inviteCode
    ..createdBy = createdBy
    ..createdAt = createdAt ?? DateTime.now()
    ..updatedAt = updatedAt
    ..members = members?.toIsar() ?? []
    ..lastSyncedAt = DateTime.now();
}

extension MemberModelX on MemberModel {
  MemberIsarModel toIsar() => MemberIsarModel()
    ..groupId = groupId
    ..userId = userId
    ..role = role
    ..joinedAt = joinedAt
    ..name = name
    ..email = email
    ..phone = phone;
}

extension GroupModelListX on List<GroupModel> {
  List<GroupIsarModel> toIsar() => map((e) => e.toIsar()).toList();
}

extension MemberModelListX on List<MemberModel> {
  List<MemberIsarModel> toIsar() => map((e) => e.toIsar()).toList();
}
