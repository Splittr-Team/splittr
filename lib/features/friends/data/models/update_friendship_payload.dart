import 'package:json_annotation/json_annotation.dart';

part 'update_friendship_payload.g.dart';

@JsonSerializable()
class UpdateFriendshipPayload {
  const UpdateFriendshipPayload({
    required this.status,
  });

  final String status;

  Map<String, dynamic> toJson() => _$UpdateFriendshipPayloadToJson(this);
}
