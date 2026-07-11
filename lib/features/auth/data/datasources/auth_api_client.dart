import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/auth/data/models/create_user_request_model.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/users')
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST('/')
  Future<UserModel> createUser(@Body() CreateUserRequestModel request);

  @GET('/me')
  Future<UserModel> getMe();
}
