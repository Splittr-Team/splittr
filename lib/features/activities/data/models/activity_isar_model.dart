import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'activity_isar_model.g.dart';

@collection
class ActivityIsarModel with IsarCacheable {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? id;

  String? groupId;
  String? actorId;
  String? actorName;
  String? actionType;
  String? description;
  String? entityType;
  String? entityId;

  @Index()
  DateTime? createdAt;
}
