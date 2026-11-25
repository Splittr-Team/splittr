import 'package:json_annotation/json_annotation.dart';

part 'update_notification_payload.g.dart';

@JsonSerializable()
class UpdateNotificationPayload {
  const UpdateNotificationPayload({
    this.isRead = true,
  });

  final bool isRead;

  Map<String, dynamic> toJson() => _$UpdateNotificationPayloadToJson(this);
}
