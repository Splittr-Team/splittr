import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'notification_isar_model.g.dart';

@collection
class NotificationIsarModel with IsarCacheable {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? id;

  String? title;
  String? body;
  bool? isRead;
  String? type;

  @Index()
  DateTime? createdAt;

  String? activityId;
}
