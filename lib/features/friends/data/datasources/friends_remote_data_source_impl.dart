import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/friends/data/datasources/friends_api_client.dart';
import 'package:splittr/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:splittr/features/friends/data/models/add_friend_payload.dart';
import 'package:splittr/features/friends/data/models/friends_response_model.dart';

@LazySingleton(as: FriendsRemoteDataSource)
final class FriendsRemoteDataSourceImpl implements FriendsRemoteDataSource {
  const FriendsRemoteDataSourceImpl(this._apiClient);

  final FriendsApiClient _apiClient;

  @override
  Future<FriendsResponseModel> getFriends({String? cursor, int? limit}) =>
      _apiClient.getFriends(cursor: cursor, limit: limit);

  @override
  Future<UserModel> addFriend({String? friendEmail, String? friendPhone}) {
    return _apiClient.addFriend(
      AddFriendPayload(friendEmail: friendEmail, friendPhone: friendPhone),
    );
  }

  @override
  Future<Unit> removeFriend(String friendId) async {
    await _apiClient.removeFriend(friendId);
    return unit;
  }
}
