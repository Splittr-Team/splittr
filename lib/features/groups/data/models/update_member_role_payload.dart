import 'package:json_annotation/json_annotation.dart';

part 'update_member_role_payload.g.dart';

@JsonSerializable()
class UpdateMemberRolePayload {
  const UpdateMemberRolePayload({required this.role});

  final String role;

  Map<String, dynamic> toJson() => _$UpdateMemberRolePayloadToJson(this);
}
