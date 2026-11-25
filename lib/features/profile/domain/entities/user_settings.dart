import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';

@freezed
class UserSettings with _$UserSettings {
  const UserSettings({
    this.autoAcceptFriendRequests,
  });

  @override
  final bool? autoAcceptFriendRequests;
}
