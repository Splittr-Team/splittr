import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';

@lazySingleton
final class RemoveFriendUseCase implements UseCase<Unit, RemoveFriendParams> {
  const RemoveFriendUseCase(this._repository);
  final FriendsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RemoveFriendParams params) {
    return _repository.removeFriend(params.friendId);
  }
}

class RemoveFriendParams extends Equatable {
  const RemoveFriendParams(this.friendId);
  final String friendId;

  @override
  List<Object?> get props => [friendId];
}
