import 'package:splittr/features/notifications/data/models/notification_isar_model.dart';
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

  NotificationIsarModel toIsar() => NotificationIsarModel()
    ..id = id
    ..title = title
    ..body = content
    ..isRead = isRead
    ..createdAt = createdAt
    ..activityId = activityId;
}

extension NotificationModelListX on List<NotificationModel> {
  List<Notification> toDomain() => map((e) => e.toDomain()).toList();

  List<NotificationIsarModel> toIsar() => map((e) => e.toIsar()).toList();
}

extension NotificationIsarModelX on NotificationIsarModel {
  Notification toDomain() => Notification(
    id: id ?? '',
    userId: '',
    actorId: '',
    actorName: '',
    activityId: activityId,
    title: title ?? '',
    content: body ?? '',
    isRead: isRead ?? false,
    createdAt: createdAt ?? DateTime.now(),
  );
}

extension NotificationIsarModelListX on List<NotificationIsarModel> {
  List<Notification> toDomain() => map((e) => e.toDomain()).toList();
}
