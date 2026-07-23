import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/core/network/pagination_model.dart';
import 'package:splittr/features/notifications/data/models/notification_model.dart';

part 'notifications_response_model.g.dart';

@JsonSerializable()
class NotificationsResponseModel {
  const NotificationsResponseModel({
    required this.data,
    required this.pagination,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseModelFromJson(json);

  final List<NotificationModel> data;
  final PaginationModel pagination;
}
