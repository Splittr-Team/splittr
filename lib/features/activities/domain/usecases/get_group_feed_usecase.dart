import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';
import 'package:splittr/features/activities/domain/repositories/activities_repository.dart';

class GetGroupFeedParams extends Equatable {
  const GetGroupFeedParams({
    required this.groupId,
    this.cursor,
    this.limit,
  });

  final String groupId;
  final String? cursor;
  final int? limit;

  @override
  List<Object?> get props => [groupId, cursor, limit];
}

@lazySingleton
final class GetGroupFeedUseCase
    implements UseCase<PaginatedList<Activity>, GetGroupFeedParams> {
  const GetGroupFeedUseCase(this._repository);

  final ActivitiesRepository _repository;

  @override
  Future<Either<Failure, PaginatedList<Activity>>> call(
    GetGroupFeedParams params,
  ) {
    return _repository.getGroupFeed(
      groupId: params.groupId,
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}
