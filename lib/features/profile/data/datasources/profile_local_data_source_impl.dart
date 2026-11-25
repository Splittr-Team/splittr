import 'package:injectable/injectable.dart';
import 'package:splittr/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:splittr/features/profile/data/models/profile_model.dart';
import 'package:splittr/features/profile/data/models/user_settings_model.dart';

@LazySingleton(as: ProfileLocalDataSource)
final class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileModel? _cachedProfile;
  UserSettingsModel? _cachedSettings;

  @override
  ProfileModel? getCachedProfile() => _cachedProfile;

  @override
  void cacheProfile(ProfileModel profile) {
    _cachedProfile = profile;
  }

  @override
  UserSettingsModel? getCachedSettings() => _cachedSettings;

  @override
  void cacheSettings(UserSettingsModel settings) {
    _cachedSettings = settings;
  }

  @override
  void clearCache() {
    _cachedProfile = null;
    _cachedSettings = null;
  }
}
