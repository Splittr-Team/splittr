import 'dart:io';

import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/profile/domain/entities/profile.dart';
import 'package:splittr/features/profile/domain/entities/user_settings.dart';

abstract interface class ProfileRepository {
  FutureEitherFailure<Profile> getProfile();

  FutureEitherFailure<Profile> updateProfile({
    String? name,
    String? defaultCurrency,
  });

  FutureEitherFailure<Profile> updateAvatar(File file);

  FutureEitherFailure<UserSettings> getProfileSettings();

  FutureEitherFailure<UserSettings> updateProfileSettings({
    bool? autoAcceptFriendRequests,
  });
}
