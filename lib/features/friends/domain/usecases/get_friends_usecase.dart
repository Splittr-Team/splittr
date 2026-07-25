import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';

@lazySingleton
final class GetFriendsUseCase
    implements UseCase<PaginatedList<User>, GetFriendsParams> {
  const GetFriendsUseCase(this._repository);

  final FriendsRepository _repository;

  @override
  Future<Either<Failure, PaginatedList<User>>> call(GetFriendsParams params) =>
      _repository.getFriends(cursor: params.cursor, limit: params.limit);
}

class GetFriendsParams extends Equatable {
  const GetFriendsParams({this.cursor, this.limit});

  final String? cursor;
  final int? limit;

  @override
  List<Object?> get props => [cursor, limit];
}
