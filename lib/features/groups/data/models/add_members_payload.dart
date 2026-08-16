import 'package:json_annotation/json_annotation.dart';

part 'add_members_payload.g.dart';

@JsonSerializable()
class AddMembersPayload {
  const AddMembersPayload({required this.userIds});

  final List<String> userIds;

  Map<String, dynamic> toJson() => _$AddMembersPayloadToJson(this);
}
