import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/friends/data/models/add_friend_payload.dart';
import 'package:splittr/features/friends/data/models/friends_response_model.dart';

part 'friends_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/friends')
abstract class FriendsApiClient {
  @factoryMethod
  factory FriendsApiClient(Dio dio) = _FriendsApiClient;

  @GET('/')
  Future<FriendsResponseModel> getFriends({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @POST('/')
  Future<UserModel> addFriend(@Body() AddFriendPayload body);

  @DELETE('/{friendId}')
  Future<void> removeFriend(@Path('friendId') String friendId);
}
