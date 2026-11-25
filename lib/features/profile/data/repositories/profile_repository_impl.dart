import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:splittr/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:splittr/features/profile/data/mappers/profile_mappers.dart';
import 'package:splittr/features/profile/data/models/update_user_payload.dart';
import 'package:splittr/features/profile/data/models/update_user_settings_payload.dart';
import 'package:splittr/features/profile/domain/entities/profile.dart';
import 'package:splittr/features/profile/domain/entities/user_settings.dart';
import 'package:splittr/features/profile/domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(
    this._apiCallHandler,
    this._remoteDataSource,
    this._localDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;

  @override
  FutureEitherFailure<Profile> getProfile() async {
    final cached = _localDataSource.getCachedProfile();
    if (cached != null) {
      return Right(cached.toDomain());
    }

    final result = await _apiCallHandler.handle(_remoteDataSource.getProfile);
    return result.map((model) {
      _localDataSource.cacheProfile(model);
      return model.toDomain();
    });
  }

  @override
  FutureEitherFailure<Profile> updateProfile({
    String? name,
    String? defaultCurrency,
  }) async {
    final payload = UpdateUserPayload(
      name: name,
      defaultCurrency: defaultCurrency,
    );
    final result = await _apiCallHandler.handle(
      () => _remoteDataSource.updateProfile(payload),
    );
    return result.map((model) {
      _localDataSource.cacheProfile(model);
      return model.toDomain();
    });
  }

  @override
  FutureEitherFailure<Profile> updateAvatar(File file) async {
    final result = await _apiCallHandler.handle(
      () => _remoteDataSource.updateAvatar(file),
    );
    return result.map((model) {
      _localDataSource.cacheProfile(model);
      return model.toDomain();
    });
  }

  @override
  FutureEitherFailure<UserSettings> getProfileSettings() async {
    final cached = _localDataSource.getCachedSettings();
    if (cached != null) {
      return Right(cached.toDomain());
    }

    final result = await _apiCallHandler.handle(
      _remoteDataSource.getProfileSettings,
    );
    return result.map((model) {
      _localDataSource.cacheSettings(model);
      return model.toDomain();
    });
  }

  @override
  FutureEitherFailure<UserSettings> updateProfileSettings({
    bool? autoAcceptFriendRequests,
  }) async {
    final payload = UpdateUserSettingsPayload(
      autoAcceptFriendRequests: autoAcceptFriendRequests,
    );
    final result = await _apiCallHandler.handle(
      () => _remoteDataSource.updateProfileSettings(payload),
    );
    return result.map((model) {
      _localDataSource.cacheSettings(model);
      return model.toDomain();
    });
  }
}
