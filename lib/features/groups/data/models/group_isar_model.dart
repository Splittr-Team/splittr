import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'group_isar_model.g.dart';

@collection
class GroupIsarModel with IsarCacheable {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? id;

  String? name;
  String? description;
  String? inviteCode;
  DateTime? inviteCodeExpiresAt;
  bool? requireAdminApproval;
  String? createdBy;
  @Index()
  DateTime? createdAt;
  DateTime? updatedAt;
  List<MemberIsarModel>? members;
}

@embedded
class MemberIsarModel {
  String? groupId;
  String? userId;
  String? role;
  String? status;
  String? joinedAt;
  String? name;
  String? email;
  String? phone;
}
