import 'package:json_annotation/json_annotation.dart';

part 'update_user_settings_payload.g.dart';

@JsonSerializable()
class UpdateUserSettingsPayload {
  const UpdateUserSettingsPayload({
    this.autoAcceptFriendRequests,
  });

  final bool? autoAcceptFriendRequests;

  Map<String, dynamic> toJson() => _$UpdateUserSettingsPayloadToJson(this);
}
