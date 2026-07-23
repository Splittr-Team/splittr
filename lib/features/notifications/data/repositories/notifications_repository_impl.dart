import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:splittr/features/notifications/data/mappers/notification.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';
import 'package:splittr/features/notifications/domain/repositories/notifications_repository.dart';

@LazySingleton(as: NotificationsRepository)
final class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(
    this._apiCallHandler,
    this._notificationsRemoteDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final NotificationsRemoteDataSource _notificationsRemoteDataSource;

  final BehaviorSubject<EitherFailure<List<Notification>>>
  _notificationsSubject = BehaviorSubject.seeded(const Right([]));

  @override
  Stream<EitherFailure<List<Notification>>> get watchNotifications =>
      _notificationsSubject.stream;

  @override
  FutureEitherFailure<PaginatedList<Notification>> getNotifications({
    String? cursor,
    int? limit,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _notificationsRemoteDataSource.getNotifications(
        cursor: cursor,
        limit: limit,
      ),
    );

    return result.map((response) {
      final newNotifications = response.data.toDomain();
      final pagination = response.pagination.toDomain();

      final currentList = _notificationsSubject.value.getOrElse((_) => []);

      final updatedList = cursor == null
          ? newNotifications
          : [...currentList, ...newNotifications];

      _notificationsSubject.add(Right(updatedList));
      return PaginatedList(
        items: newNotifications,
        pagination: pagination,
      );
    });
  }

  @override
  FutureEitherFailure<void> readAllNotifications() async {
    final result = await _apiCallHandler.handle(
      _notificationsRemoteDataSource.readAllNotifications,
    );
    if (result.isRight()) unawaited(getNotifications());
    return result;
  }

  @override
  FutureEitherFailure<void> readNotification(String id) async {
    final result = await _apiCallHandler.handle(
      () => _notificationsRemoteDataSource.readNotification(id),
    );
    if (result.isRight()) unawaited(getNotifications());
    return result;
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _notificationsSubject.close();
  }
}
