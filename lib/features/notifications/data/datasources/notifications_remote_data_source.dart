import 'package:splittr/features/notifications/data/models/notifications_response_model.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications({
    String? cursor,
    int? limit,
  });

  Future<void> readAllNotifications();

  Future<void> readNotification(String id);
}
