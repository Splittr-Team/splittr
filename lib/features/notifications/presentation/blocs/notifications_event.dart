part of 'notifications_bloc.dart';

@freezed
class NotificationsEvent extends BaseEvent with _$NotificationsEvent {
  const NotificationsEvent._();

  const factory NotificationsEvent.started() = _Started;

  const factory NotificationsEvent.notificationsUpdated({
    required List<Notification> notifications,
  }) = _NotificationsUpdated;

  const factory NotificationsEvent.notificationsFailed({
    required Failure failure,
  }) = _NotificationsFailed;

  const factory NotificationsEvent.markAllRead() = _MarkAllRead;

  const factory NotificationsEvent.markRead({
    required String id,
  }) = _MarkRead;
}
