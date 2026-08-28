import 'package:json_annotation/json_annotation.dart';

part 'decide_join_request_payload.g.dart';

@JsonSerializable()
class DecideJoinRequestPayload {
  const DecideJoinRequestPayload({required this.action});

  final String action;

  Map<String, dynamic> toJson() => _$DecideJoinRequestPayloadToJson(this);
}
