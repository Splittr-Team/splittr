import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/notifications/data/models/notification_isar_model.dart';

abstract interface class NotificationsLocalDataSource {
  Stream<List<NotificationIsarModel>> watchNotifications();

  Future<List<NotificationIsarModel>> getNotifications({int? limit});

  Future<void> saveNotification(NotificationIsarModel notification);

  Future<void> saveNotifications({
    required List<NotificationIsarModel> notifications,
    required String? nextCursor,
    required bool hasMore,
  });

  Future<PaginationMetadataIsarModel?> getPaginationMetadata(
    FeatureCacheKey featureKey,
  );

  Future<void> markAllAsRead();

  Future<void> markAsRead(String id);
}
