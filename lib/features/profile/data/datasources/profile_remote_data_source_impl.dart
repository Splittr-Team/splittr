import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:splittr/features/profile/data/datasources/profile_api_client.dart';
import 'package:splittr/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:splittr/features/profile/data/models/profile_model.dart';
import 'package:splittr/features/profile/data/models/update_user_payload.dart';
import 'package:splittr/features/profile/data/models/update_user_settings_payload.dart';
import 'package:splittr/features/profile/data/models/user_settings_model.dart';

@LazySingleton(as: ProfileRemoteDataSource)
final class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._apiClient);

  final ProfileApiClient _apiClient;

  @override
  Future<ProfileModel> getProfile() => _apiClient.getProfile();

  @override
  Future<ProfileModel> updateProfile(UpdateUserPayload payload) =>
      _apiClient.updateProfile(payload);

  @override
  Future<ProfileModel> updateAvatar(File file) => _apiClient.updateAvatar(file);

  @override
  Future<UserSettingsModel> getProfileSettings() =>
      _apiClient.getProfileSettings();

  @override
  Future<UserSettingsModel> updateProfileSettings(
    UpdateUserSettingsPayload payload,
  ) => _apiClient.updateProfileSettings(payload);
}
