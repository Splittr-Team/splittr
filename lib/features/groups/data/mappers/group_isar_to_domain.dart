import 'package:sky_utils/sky_utils.dart';
import 'package:splittr/features/groups/data/models/group_isar_model.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';

extension GroupIsarModelX on GroupIsarModel {
  Group toDomain() => Group(
    id: id,
    name: name,
    description: description,
    inviteCode: inviteCode,
    inviteCodeExpiresAt: inviteCodeExpiresAt,
    requireAdminApproval: requireAdminApproval ?? false,
    createdBy: createdBy,
    createdAt: createdAt,
    updatedAt: updatedAt,
    members: members?.toDomain() ?? [],
  );
}

extension MemberIsarModelX on MemberIsarModel {
  Member toDomain() => Member(
    groupId: groupId,
    userId: userId,
    role: Role.values.byNameOrNull(role),
    status: MemberStatus.values.byNameOrNull(status),
    joinedAt: joinedAt,
    name: name,
    email: email,
    phone: phone,
  );
}

extension GroupIsarModelListX on List<GroupIsarModel> {
  List<Group> toDomain() => map((e) => e.toDomain()).toList();
}

extension MemberIsarModelListX on List<MemberIsarModel> {
  List<Member> toDomain() => map((e) => e.toDomain()).toList();
}
