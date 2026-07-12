import 'package:json_annotation/json_annotation.dart';

part 'create_group_payload.g.dart';

@JsonSerializable()
class CreateGroupPayload {
  const CreateGroupPayload({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  Map<String, dynamic> toJson() => _$CreateGroupPayloadToJson(this);
}
