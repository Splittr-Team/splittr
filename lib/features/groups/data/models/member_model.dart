import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class MemberModel {
  const MemberModel({
    this.groupId,
    this.userId,
    this.role,
    this.joinedAt,
    this.name,
    this.email,
    this.phone,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  final String? groupId;
  final String? userId;
  final String? role;
  final String? joinedAt;
  final String? name;
  final String? email;
  final String? phone;
}
