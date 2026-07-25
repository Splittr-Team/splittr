import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';

enum EntityType { expense, settlement, member, group }

enum ActionType {
  expenseCreated,
  settlement,
  memberAdded,
  memberJoined,
  memberLeft,
  memberKicked,
  memberRoleUpdated,
  groupCreated,
  groupArchived,
}

@freezed
class Activity with _$Activity {
  const Activity({
    required this.id,
    required this.actionType,
    required this.description,
    required this.createdAt,
    this.groupId,
    this.actorId,
    this.actorName,
    this.entityType,
    this.entityId,
    this.metadata,
  });

  @override
  final String id;
  @override
  final String actionType;
  @override
  final String description;
  @override
  final DateTime createdAt;
  @override
  final String? groupId;
  @override
  final String? actorId;
  @override
  final String? actorName;
  @override
  final String? entityType;
  @override
  final String? entityId;
  @override
  final Map<String, dynamic>? metadata;
}
