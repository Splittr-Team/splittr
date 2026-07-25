import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/friends/data/models/friends_response_model.dart';

abstract interface class FriendsRemoteDataSource {
  Future<FriendsResponseModel> getFriends({String? cursor, int? limit});

  Future<UserModel> addFriend({String? friendEmail, String? friendPhone});

  Future<Unit> removeFriend(String friendId);
}
