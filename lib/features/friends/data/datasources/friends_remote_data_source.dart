import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/friends/data/models/friend_model.dart';
import 'package:splittr/features/friends/data/models/friends_model.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';

abstract interface class FriendsRemoteDataSource {
  Future<FriendsModel> getFriends({
    String? cursor,
    int? limit,
    FriendshipStatus? status,
  });

  Future<FriendModel> addFriend({String? friendEmail, String? friendPhone});

  Future<FriendModel> updateFriendshipStatus({
    required String friendId,
    required FriendshipStatus status,
  });

  Future<Unit> removeFriend(String friendId);
}
