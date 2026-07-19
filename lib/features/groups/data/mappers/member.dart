import 'package:splittr/features/groups/data/models/member_model.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';

extension MemberModelX on MemberModel {
  Member toDomain() => Member(
    groupId: groupId,
    userId: userId,
    role: role,
    joinedAt: joinedAt,
    name: name,
    email: email,
    phone: phone,
  );
}

extension MemberModelListX on List<MemberModel> {
  List<Member> toDomain() => map((e) => e.toDomain()).toList();
}
