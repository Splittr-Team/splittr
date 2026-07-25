import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';

abstract interface class ActivitiesRepository {
  Stream<EitherFailure<List<Activity>>> watchActivities({String? groupId});

  FutureEitherFailure<PaginatedList<Activity>> getActivities({
    String? cursor,
    int? limit,
  });

  FutureEitherFailure<PaginatedList<Activity>> getGroupFeed({
    required String groupId,
    String? cursor,
    int? limit,
  });
}
