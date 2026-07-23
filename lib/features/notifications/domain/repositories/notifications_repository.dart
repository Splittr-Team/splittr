import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';

abstract interface class NotificationsRepository {
  Stream<EitherFailure<List<Notification>>> get watchNotifications;

  FutureEitherFailure<PaginatedList<Notification>> getNotifications({
    String? cursor,
    int? limit,
  });

  FutureEitherFailure<void> readAllNotifications();

  FutureEitherFailure<void> readNotification(String id);

  Future<void> dispose();
}
