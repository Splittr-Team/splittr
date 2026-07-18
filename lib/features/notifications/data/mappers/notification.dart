import 'package:splittr/features/notifications/data/models/notification_model.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';

extension NotificationModelX on NotificationModel {
  Notification toDomain() => Notification(
    id: id,
    userId: userId,
    actorId: actorId,
    actorName: actorName,
    activityId: activityId,
    title: title,
    content: content,
    isRead: isRead,
    createdAt: createdAt,
  );
}

extension NotificationModelListX on List<NotificationModel> {
  List<Notification> toDomain() => map((e) => e.toDomain()).toList();
}
