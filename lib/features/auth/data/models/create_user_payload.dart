import 'package:json_annotation/json_annotation.dart';

part 'create_user_payload.g.dart';

@JsonSerializable()
class CreateUserPayload {
  const CreateUserPayload({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  Map<String, dynamic> toJson() => _$CreateUserPayloadToJson(this);
}
