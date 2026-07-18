import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
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
  FutureEitherFailure<List<Notification>> getNotifications() async {
    final result = await _apiCallHandler.handle(
      _notificationsRemoteDataSource.getNotifications,
    );
    final mapped = result.map((models) => models.toDomain());
    _notificationsSubject.add(mapped);
    return mapped;
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
