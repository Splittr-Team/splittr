import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  const NotificationModel({
    this.id,
    this.userId,
    this.actorId,
    this.actorName,
    this.activityId,
    this.title,
    this.content,
    this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  final String? id;
  final String? userId;
  final String? actorId;
  final String? actorName;
  final String? activityId;
  final String? title;
  final String? content;
  final bool? isRead;
  final DateTime? createdAt;
}
