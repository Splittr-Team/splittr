import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';

@lazySingleton
final class UpdateFriendshipStatusUseCase
    implements UseCase<Friend, UpdateFriendshipStatusParams> {
  const UpdateFriendshipStatusUseCase(this._repository);

  final FriendsRepository _repository;

  @override
  Future<Either<Failure, Friend>> call(UpdateFriendshipStatusParams params) {
    return _repository.updateFriendshipStatus(
      friendId: params.friendId,
      status: params.status,
    );
  }
}

class UpdateFriendshipStatusParams extends Equatable {
  const UpdateFriendshipStatusParams({
    required this.friendId,
    required this.status,
  });

  final String friendId;
  final FriendshipStatus status;

  @override
  List<Object?> get props => [friendId, status];
}
