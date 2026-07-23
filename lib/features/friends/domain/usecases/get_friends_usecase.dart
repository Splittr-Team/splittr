import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';

@lazySingleton
final class GetFriendsUseCase implements UseCase<List<User>, NoParams> {
  const GetFriendsUseCase(this._repository);

  final FriendsRepository _repository;

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) =>
      _repository.getFriends();
}
