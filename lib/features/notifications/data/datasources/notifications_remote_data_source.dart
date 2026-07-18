import 'package:splittr/features/notifications/data/models/notification_model.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();

  Future<void> readAllNotifications();

  Future<void> readNotification(String id);
}
