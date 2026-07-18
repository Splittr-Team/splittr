import 'package:json_annotation/json_annotation.dart';

part 'join_group_payload.g.dart';

@JsonSerializable()
class JoinGroupPayload {
  const JoinGroupPayload({
    required this.inviteCode,
  });

  final String inviteCode;

  Map<String, dynamic> toJson() => _$JoinGroupPayloadToJson(this);
}
