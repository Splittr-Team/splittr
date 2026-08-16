import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';

abstract interface class FriendsRepository {
  Stream<EitherFailure<List<Friend>>> watchFriends();

  FutureEitherFailure<PaginatedList<Friend>> getFriends({
    String? cursor,
    int? limit,
    FriendshipStatus? status,
  });

  FutureEitherFailure<Friend> addFriend({
    String? friendEmail,
    String? friendPhone,
  });

  FutureEitherFailure<Friend> updateFriendshipStatus({
    required String friendId,
    required FriendshipStatus status,
  });

  FutureEitherFailure<Unit> removeFriend(String friendId);
}
