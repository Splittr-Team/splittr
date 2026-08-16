import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_utils/sky_utils.dart';
import 'package:splittr/features/friends/data/datasources/friends_api_client.dart';
import 'package:splittr/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:splittr/features/friends/data/models/add_friend_payload.dart';
import 'package:splittr/features/friends/data/models/friend_model.dart';
import 'package:splittr/features/friends/data/models/friends_model.dart';
import 'package:splittr/features/friends/data/models/update_friendship_payload.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';

@LazySingleton(as: FriendsRemoteDataSource)
final class FriendsRemoteDataSourceImpl implements FriendsRemoteDataSource {
  const FriendsRemoteDataSourceImpl(this._apiClient);

  final FriendsApiClient _apiClient;

  @override
  Future<FriendsModel> getFriends({
    String? cursor,
    int? limit,
    FriendshipStatus? status,
  }) => _apiClient.getFriends(
    cursor: cursor,
    limit: limit,
    status: status?.constantCase,
  );

  @override
  Future<FriendModel> addFriend({String? friendEmail, String? friendPhone}) {
    return _apiClient.addFriend(
      AddFriendPayload(friendEmail: friendEmail, friendPhone: friendPhone),
    );
  }

  @override
  Future<FriendModel> updateFriendshipStatus({
    required String friendId,
    required FriendshipStatus status,
  }) {
    return _apiClient.updateFriendshipStatus(
      friendId,
      UpdateFriendshipPayload(status: status.constantCase),
    );
  }

  @override
  Future<Unit> removeFriend(String friendId) async {
    await _apiClient.removeFriend(friendId);
    return unit;
  }
}
