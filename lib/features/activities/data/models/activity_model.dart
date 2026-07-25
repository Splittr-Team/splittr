import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

@JsonSerializable(createToJson: false)
class ActivityModel {
  const ActivityModel({
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
    this.payload,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  final String id;
  final String actionType;
  final String description;
  final DateTime createdAt;
  final String? groupId;
  final String? actorId;
  final String? actorName;
  final String? entityType;
  final String? entityId;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? payload;
}
