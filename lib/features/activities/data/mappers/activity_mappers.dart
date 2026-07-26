import 'package:splittr/features/activities/data/models/activity_isar_model.dart';
import 'package:splittr/features/activities/data/models/activity_model.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';

extension ActivityModelX on ActivityModel {
  Activity toDomain() => Activity(
    id: id,
    actionType: actionType,
    description: description,
    createdAt: createdAt,
    groupId: groupId,
    actorId: actorId,
    actorName: actorName,
    entityType: entityType,
    entityId: entityId,
    metadata: metadata ?? payload,
  );

  ActivityIsarModel toIsar() => ActivityIsarModel()
    ..id = id
    ..groupId = groupId
    ..actorId = actorId
    ..actorName = actorName
    ..actionType = actionType
    ..description = description
    ..entityType = entityType
    ..entityId = entityId
    ..createdAt = createdAt;
}

extension ActivityModelListX on List<ActivityModel> {
  List<Activity> toDomain() => map((e) => e.toDomain()).toList();

  List<ActivityIsarModel> toIsar() => map((e) => e.toIsar()).toList();
}

extension ActivityIsarModelX on ActivityIsarModel {
  Activity toDomain() => Activity(
    id: id ?? '',
    actionType: actionType ?? '',
    description: description ?? '',
    createdAt: createdAt ?? DateTime.now(),
    groupId: groupId,
    actorId: actorId,
    actorName: actorName,
    entityType: entityType,
    entityId: entityId,
  );
}

extension ActivityIsarModelListX on List<ActivityIsarModel> {
  List<Activity> toDomain() => map((e) => e.toDomain()).toList();
}
