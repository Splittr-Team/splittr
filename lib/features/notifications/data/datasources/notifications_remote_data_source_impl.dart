import 'package:injectable/injectable.dart';
import 'package:splittr/features/notifications/data/datasources/notifications_api_client.dart';
import 'package:splittr/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:splittr/features/notifications/data/models/notifications_response_model.dart';
import 'package:splittr/features/notifications/data/models/update_notification_payload.dart';

@LazySingleton(as: NotificationsRemoteDataSource)
final class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl(this._notificationsApiClient);

  final NotificationsApiClient _notificationsApiClient;

  @override
  Future<NotificationsResponseModel> getNotifications({
    String? cursor,
    int? limit,
  }) => _notificationsApiClient.getNotifications(
    cursor: cursor,
    limit: limit,
  );

  @override
  Future<void> readAllNotifications() =>
      _notificationsApiClient.readAllNotifications(
        const UpdateNotificationPayload(),
      );

  @override
  Future<void> readNotification(String id) =>
      _notificationsApiClient.readNotification(
        id,
        const UpdateNotificationPayload(),
      );
}
