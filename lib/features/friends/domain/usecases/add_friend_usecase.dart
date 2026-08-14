import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';

@lazySingleton
final class AddFriendUseCase implements UseCase<Friend, AddFriendParams> {
  const AddFriendUseCase(this._repository);

  final FriendsRepository _repository;

  @override
  Future<Either<Failure, Friend>> call(AddFriendParams params) {
    return _repository.addFriend(
      friendEmail: params.friendEmail,
      friendPhone: params.friendPhone,
    );
  }
}

class AddFriendParams extends Equatable {
  const AddFriendParams({this.friendEmail, this.friendPhone});

  final String? friendEmail;
  final String? friendPhone;

  @override
  List<Object?> get props => [friendEmail, friendPhone];
}
