import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/auth/data/models/create_user_payload.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/profile/data/models/update_user_payload.dart';
import 'package:splittr/features/profile/data/models/update_user_settings_payload.dart';
import 'package:splittr/features/profile/data/models/user_settings_model.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/users')
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST('/')
  Future<UserModel> createUser(@Body() CreateUserPayload body);

  @GET('/me')
  Future<UserModel> getMe();

  @PATCH('/me')
  Future<UserModel> updateMe(@Body() UpdateUserPayload body);

  @GET('/me/settings')
  Future<UserSettingsModel> getSettings();

  @PATCH('/me/settings')
  Future<UserSettingsModel> updateSettings(
    @Body() UpdateUserSettingsPayload body,
  );
}
