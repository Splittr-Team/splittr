import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';

abstract interface class FriendsRepository {
  Stream<EitherFailure<List<User>>> watchFriends();

  FutureEitherFailure<PaginatedList<User>> getFriends({
    String? cursor,
    int? limit,
  });

  FutureEitherFailure<User> addFriend({
    String? friendEmail,
    String? friendPhone,
  });

  FutureEitherFailure<Unit> removeFriend(String friendId);
}
