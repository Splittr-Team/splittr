import 'package:injectable/injectable.dart';
import 'package:splittr/features/notifications/data/datasources/notifications_api_client.dart';
import 'package:splittr/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:splittr/features/notifications/data/models/notification_model.dart';

@LazySingleton(as: NotificationsRemoteDataSource)
final class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl(this._notificationsApiClient);

  final NotificationsApiClient _notificationsApiClient;

  @override
  Future<List<NotificationModel>> getNotifications() =>
      _notificationsApiClient.getNotifications();

  @override
  Future<void> readAllNotifications() =>
      _notificationsApiClient.readAllNotifications();

  @override
  Future<void> readNotification(String id) =>
      _notificationsApiClient.readNotification(id);
}
