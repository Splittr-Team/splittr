import 'package:splittr/features/profile/data/models/profile_model.dart';
import 'package:splittr/features/profile/data/models/user_settings_model.dart';
import 'package:splittr/features/profile/domain/entities/profile.dart';
import 'package:splittr/features/profile/domain/entities/user_settings.dart';

extension ProfileModelX on ProfileModel {
  Profile toDomain() => Profile(
    id: id,
    email: email,
    name: name,
    avatarUrl: avatarUrl,
    defaultCurrency: defaultCurrency,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension ProfileModelListX on List<ProfileModel> {
  List<Profile> toDomain() => map((e) => e.toDomain()).toList();
}

extension UserSettingsModelX on UserSettingsModel {
  UserSettings toDomain() => UserSettings(
    autoAcceptFriendRequests: autoAcceptFriendRequests,
  );
}

extension UserSettingsModelListX on List<UserSettingsModel> {
  List<UserSettings> toDomain() => map((e) => e.toDomain()).toList();
}
