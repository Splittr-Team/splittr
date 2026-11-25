import 'package:json_annotation/json_annotation.dart';

part 'create_group_payload.g.dart';

@JsonSerializable()
class CreateGroupPayload {
  const CreateGroupPayload({
    required this.name,
    required this.description,
    this.requireAdminApproval,
  });

  final String name;
  final String description;
  final bool? requireAdminApproval;

  Map<String, dynamic> toJson() => _$CreateGroupPayloadToJson(this);
}
