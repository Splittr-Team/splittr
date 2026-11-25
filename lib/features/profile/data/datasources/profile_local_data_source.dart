import 'package:splittr/features/profile/data/models/profile_model.dart';
import 'package:splittr/features/profile/data/models/user_settings_model.dart';

abstract interface class ProfileLocalDataSource {
  ProfileModel? getCachedProfile();

  void cacheProfile(ProfileModel profile);

  UserSettingsModel? getCachedSettings();

  void cacheSettings(UserSettingsModel settings);

  void clearCache();
}
