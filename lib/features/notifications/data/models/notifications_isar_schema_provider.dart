import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/notifications/data/models/notification_isar_model.dart';

class NotificationsIsarSchemaProvider implements IsarSchemaProvider {
  const NotificationsIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    NotificationIsarModelSchema,
  ];
}
