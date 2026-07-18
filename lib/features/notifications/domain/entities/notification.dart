import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';

@freezed
class Notification with _$Notification {
  const Notification({
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

  @override
  final String? id;
  @override
  final String? userId;
  @override
  final String? actorId;
  @override
  final String? actorName;
  @override
  final String? activityId;
  @override
  final String? title;
  @override
  final String? content;
  @override
  final bool? isRead;
  @override
  final DateTime? createdAt;
}
