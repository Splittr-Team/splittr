import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/profile/data/models/profile_model.dart';
import 'package:splittr/features/profile/data/models/update_user_payload.dart';
import 'package:splittr/features/profile/data/models/update_user_settings_payload.dart';
import 'package:splittr/features/profile/data/models/user_settings_model.dart';

part 'profile_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/users')
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET('/me')
  Future<ProfileModel> getProfile();

  @PATCH('/me')
  Future<ProfileModel> updateProfile(@Body() UpdateUserPayload payload);

  @POST('/me/avatar')
  @MultiPart()
  Future<ProfileModel> updateAvatar(@Part(name: 'file') File file);

  @GET('/me/settings')
  Future<UserSettingsModel> getProfileSettings();

  @PATCH('/me/settings')
  Future<UserSettingsModel> updateProfileSettings(
    @Body() UpdateUserSettingsPayload payload,
  );
}
