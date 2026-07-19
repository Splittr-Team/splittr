import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class GetGroupsUseCase
    implements UseCase<PaginatedList<Group>, GetGroupsParams> {
  const GetGroupsUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, PaginatedList<Group>>> call(GetGroupsParams params) {
    return _groupsRepository.getGroups(
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}

class GetGroupsParams extends Equatable {
  const GetGroupsParams({this.cursor, this.limit});

  final String? cursor;
  final int? limit;

  @override
  List<Object?> get props => [cursor, limit];
}
