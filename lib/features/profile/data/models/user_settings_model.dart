import 'package:json_annotation/json_annotation.dart';

part 'user_settings_model.g.dart';

@JsonSerializable()
class UserSettingsModel {
  const UserSettingsModel({
    this.autoAcceptFriendRequests,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  final bool? autoAcceptFriendRequests;
}
