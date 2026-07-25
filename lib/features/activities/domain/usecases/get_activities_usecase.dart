import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';
import 'package:splittr/features/activities/domain/repositories/activities_repository.dart';

@lazySingleton
final class GetActivitiesUseCase
    implements UseCase<PaginatedList<Activity>, GetActivitiesParams> {
  const GetActivitiesUseCase(this._repository);

  final ActivitiesRepository _repository;

  @override
  Future<Either<Failure, PaginatedList<Activity>>> call(
    GetActivitiesParams params,
  ) {
    return _repository.getActivities(
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}

class GetActivitiesParams extends Equatable {
  const GetActivitiesParams({this.cursor, this.limit});

  final String? cursor;
  final int? limit;

  @override
  List<Object?> get props => [cursor, limit];
}
