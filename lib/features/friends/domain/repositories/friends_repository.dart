import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';

abstract interface class FriendsRepository {
  FutureEitherFailure<List<User>> getFriends();

  FutureEitherFailure<User> addFriend({
    String? friendEmail,
    String? friendPhone,
  });

  FutureEitherFailure<Unit> removeFriend(String friendId);
}
