import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:splittr/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:splittr/features/notifications/data/mappers/notification.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';
import 'package:splittr/features/notifications/domain/repositories/notifications_repository.dart';

@LazySingleton(as: NotificationsRepository)
final class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(
    this._apiCallHandler,
    this._notificationsRemoteDataSource,
    this._notificationsLocalDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final NotificationsRemoteDataSource _notificationsRemoteDataSource;
  final NotificationsLocalDataSource _notificationsLocalDataSource;
  final Mutex _syncLock = Mutex();

  @override
  Stream<EitherFailure<List<Notification>>> get watchNotifications =>
      _notificationsLocalDataSource.watchNotifications().map(
        (models) => Right(models.toDomain()),
      );

  @override
  FutureEitherFailure<PaginatedList<Notification>> getNotifications({
    String? cursor,
    int? limit,
  }) async {
    return _syncLock.protect(() async {
      var effectiveCursor = cursor;

      if (cursor != null) {
        final meta = await _notificationsLocalDataSource.getPaginationMetadata(
          FeatureCacheKey.notifications,
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
        () => _notificationsRemoteDataSource.getNotifications(
          cursor: effectiveCursor,
          limit: limit,
        ),
      );

      return result.fold(
        Left.new,
        (response) async {
          final domainNotifications = response.data.toDomain();
          final pagination = response.pagination.toDomain();

          await _notificationsLocalDataSource.saveNotifications(
            notifications: response.data.toIsar(),
            nextCursor: pagination.nextCursor,
            hasMore: pagination.hasMore,
          );

          return Right(
            PaginatedList(
              items: domainNotifications,
              pagination: pagination,
            ),
          );
        },
      );
    });
  }

  @override
  FutureEitherFailure<void> readAllNotifications() async {
    final result = await _apiCallHandler.handle(
      _notificationsRemoteDataSource.readAllNotifications,
    );
    if (result.isRight()) {
      await _notificationsLocalDataSource.markAllAsRead();
    }
    return result;
  }

  @override
  FutureEitherFailure<void> readNotification(String id) async {
    final result = await _apiCallHandler.handle(
      () => _notificationsRemoteDataSource.readNotification(id),
    );
    if (result.isRight()) {
      await _notificationsLocalDataSource.markAsRead(id);
    }
    return result;
  }

  @override
  @disposeMethod
  Future<void> dispose() async {}
}
