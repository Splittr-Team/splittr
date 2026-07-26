import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:splittr/features/notifications/data/models/notification_isar_model.dart';

@LazySingleton(as: NotificationsLocalDataSource)
class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  NotificationsLocalDataSourceImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<NotificationIsarModel>> watchNotifications() {
    return _isar.notificationIsarModels.where().sortByCreatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  @override
  Future<List<NotificationIsarModel>> getNotifications({int? limit}) async {
    final query = _isar.notificationIsarModels.where().sortByCreatedAtDesc();
    if (limit != null) {
      return query.limit(limit).findAll();
    }
    return query.findAll();
  }

  @override
  Future<void> saveNotification(NotificationIsarModel notification) async {
    await _isar.writeTxn(() async {
      await _isar.notificationIsarModels.put(notification);
    });
  }

  @override
  Future<void> saveNotifications({
    required List<NotificationIsarModel> notifications,
    required String? nextCursor,
    required bool hasMore,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.notificationIsarModels.putAll(notifications);

      final meta = PaginationMetadataIsarModel()
        ..featureKey = FeatureCacheKey.notifications
        ..nextCursor = nextCursor
        ..hasMore = hasMore
        ..lastSyncedAt = DateTime.now();

      await _isar.paginationMetadataIsarModels.put(meta);
    });
  }

  @override
  Future<PaginationMetadataIsarModel?> getPaginationMetadata(
    FeatureCacheKey featureKey,
  ) async {
    return _isar.paginationMetadataIsarModels
        .filter()
        .featureKeyEqualTo(featureKey)
        .findFirst();
  }

  @override
  Future<void> markAllAsRead() async {
    await _isar.writeTxn(() async {
      final items = await _isar.notificationIsarModels.where().findAll();
      for (final item in items) {
        item.isRead = true;
      }
      await _isar.notificationIsarModels.putAll(items);
    });
  }

  @override
  Future<void> markAsRead(String id) async {
    await _isar.writeTxn(() async {
      final item = await _isar.notificationIsarModels
          .filter()
          .idEqualTo(id)
          .findFirst();
      if (item != null) {
        item.isRead = true;
        await _isar.notificationIsarModels.put(item);
      }
    });
  }
}
