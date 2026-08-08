import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';

@lazySingleton
final class WatchFriendsUseCase implements StreamUseCase<List<User>, NoParams> {
  const WatchFriendsUseCase(this._friendsRepository);

  final FriendsRepository _friendsRepository;

  @override
  StreamEitherFailure<List<User>> call(NoParams params) {
    return _friendsRepository.watchFriends();
  }
}
