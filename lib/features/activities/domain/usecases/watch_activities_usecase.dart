import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';
import 'package:splittr/features/activities/domain/repositories/activities_repository.dart';

@lazySingleton
final class WatchActivitiesUseCase
    implements StreamUseCase<List<Activity>, WatchActivitiesParams> {
  const WatchActivitiesUseCase(this._repository);

  final ActivitiesRepository _repository;

  @override
  Stream<Either<Failure, List<Activity>>> call(WatchActivitiesParams params) {
    return _repository.watchActivities(groupId: params.groupId);
  }
}

class WatchActivitiesParams extends Equatable {
  const WatchActivitiesParams({this.groupId});

  final String? groupId;

  @override
  List<Object?> get props => [groupId];
}
