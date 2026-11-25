import 'dart:io';

import 'package:splittr/features/profile/data/models/profile_model.dart';
import 'package:splittr/features/profile/data/models/update_user_payload.dart';
import 'package:splittr/features/profile/data/models/update_user_settings_payload.dart';
import 'package:splittr/features/profile/data/models/user_settings_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile(UpdateUserPayload payload);

  Future<ProfileModel> updateAvatar(File file);

  Future<UserSettingsModel> getProfileSettings();

  Future<UserSettingsModel> updateProfileSettings(
    UpdateUserSettingsPayload payload,
  );
}
