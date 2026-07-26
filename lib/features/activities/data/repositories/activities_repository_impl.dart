import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/activities/data/datasources/activities_local_data_source.dart';
import 'package:splittr/features/activities/data/datasources/activities_remote_data_source.dart';
import 'package:splittr/features/activities/data/mappers/activity_mappers.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';
import 'package:splittr/features/activities/domain/repositories/activities_repository.dart';

@LazySingleton(as: ActivitiesRepository)
final class ActivitiesRepositoryImpl implements ActivitiesRepository {
  ActivitiesRepositoryImpl(
    this._apiCallHandler,
    this._activitiesRemoteDataSource,
    this._activitiesLocalDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final ActivitiesRemoteDataSource _activitiesRemoteDataSource;
  final ActivitiesLocalDataSource _activitiesLocalDataSource;
  final Mutex _syncLock = Mutex();

  @override
  Stream<EitherFailure<List<Activity>>> watchActivities({String? groupId}) =>
      _activitiesLocalDataSource
          .watchActivities(groupId: groupId)
          .map((models) => Right(models.toDomain()));

  @override
  FutureEitherFailure<PaginatedList<Activity>> getActivities({
    String? cursor,
    int? limit,
  }) async {
    return _syncLock.protect(() async {
      var effectiveCursor = cursor;

      if (cursor != null) {
        final meta = await _activitiesLocalDataSource.getPaginationMetadata(
          FeatureCacheKey.activities,
        );
        if (meta != null && !meta.hasMore) {
          return const Right(
            PaginatedList(
              items: [],
              pagination: Pagination(hasMore: false),
            ),
          );
        }
        effectiveCursor = meta?.nextCursor ?? cursor;
      }

      final result = await _apiCallHandler.handle(
        () => _activitiesRemoteDataSource.getActivities(
          cursor: effectiveCursor,
          limit: limit,
        ),
      );

      return result.fold(
        Left.new,
        (response) async {
          final domainActivities = response.data.toDomain();
          final pagination = response.pagination.toDomain();

          await _activitiesLocalDataSource.saveActivities(
            activities: response.data.toIsar(),
            nextCursor: pagination.nextCursor,
            hasMore: pagination.hasMore,
          );

          return Right(
            PaginatedList(
              items: domainActivities,
              pagination: pagination,
            ),
          );
        },
      );
    });
  }

  @override
  FutureEitherFailure<PaginatedList<Activity>> getGroupFeed({
    required String groupId,
    String? cursor,
    int? limit,
  }) async {
    return _syncLock.protect(() async {
      var effectiveCursor = cursor;

      if (cursor != null) {
        final meta = await _activitiesLocalDataSource.getPaginationMetadata(
          FeatureCacheKey.activities,
        );
        if (meta != null && !meta.hasMore) {
          return const Right(
            PaginatedList(
              items: [],
              pagination: Pagination(hasMore: false),
            ),
          );
        }
        effectiveCursor = meta?.nextCursor ?? cursor;
      }

      final result = await _apiCallHandler.handle(
        () => _activitiesRemoteDataSource.getGroupFeed(
          groupId: groupId,
          cursor: effectiveCursor,
          limit: limit,
        ),
      );

      return result.fold(
        Left.new,
        (response) async {
          final domainActivities = response.data.toDomain();
          final pagination = response.pagination.toDomain();

          await _activitiesLocalDataSource.saveActivities(
            activities: response.data.toIsar(),
            nextCursor: pagination.nextCursor,
            hasMore: pagination.hasMore,
          );

          return Right(
            PaginatedList(
              items: domainActivities,
              pagination: pagination,
            ),
          );
        },
      );
    });
  }
}
