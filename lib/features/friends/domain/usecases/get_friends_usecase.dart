import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';

@lazySingleton
final class GetFriendsUseCase
    implements UseCase<PaginatedList<Friend>, GetFriendsParams> {
  const GetFriendsUseCase(this._repository);

  final FriendsRepository _repository;

  @override
  Future<Either<Failure, PaginatedList<Friend>>> call(
    GetFriendsParams params,
  ) => _repository.getFriends(
    cursor: params.cursor,
    limit: params.limit,
    status: params.status,
  );
}

class GetFriendsParams extends Equatable {
  const GetFriendsParams({this.cursor, this.limit, this.status});

  final String? cursor;
  final int? limit;
  final FriendshipStatus? status;

  @override
  List<Object?> get props => [cursor, limit, status];
}
