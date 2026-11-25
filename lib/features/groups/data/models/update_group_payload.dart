import 'package:json_annotation/json_annotation.dart';

part 'update_group_payload.g.dart';

@JsonSerializable()
class UpdateGroupPayload {
  const UpdateGroupPayload({
    this.name,
    this.description,
    this.requireAdminApproval,
  });

  final String? name;
  final String? description;
  final bool? requireAdminApproval;

  Map<String, dynamic> toJson() => _$UpdateGroupPayloadToJson(this);
}
