import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/friends/data/models/add_friend_payload.dart';
import 'package:splittr/features/friends/data/models/friend_model.dart';
import 'package:splittr/features/friends/data/models/friends_model.dart';
import 'package:splittr/features/friends/data/models/update_friendship_payload.dart';

part 'friends_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/friends')
abstract class FriendsApiClient {
  @factoryMethod
  factory FriendsApiClient(Dio dio) = _FriendsApiClient;

  @GET('/')
  Future<FriendsModel> getFriends({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('status') String? status,
  });

  @POST('/')
  Future<FriendModel> addFriend(@Body() AddFriendPayload body);

  @PATCH('/{friendId}')
  Future<FriendModel> updateFriendshipStatus(
    @Path('friendId') String friendId,
    @Body() UpdateFriendshipPayload body,
  );

  @DELETE('/{friendId}')
  Future<void> removeFriend(@Path('friendId') String friendId);
}
