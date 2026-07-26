import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/core/network/pagination_model.dart';
import 'package:splittr/features/activities/data/models/activity_model.dart';

part 'activities_response_model.g.dart';

@JsonSerializable()
class ActivitiesResponseModel {
  const ActivitiesResponseModel({
    required this.data,
    required this.pagination,
  });

  factory ActivitiesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesResponseModelFromJson(json);

  final List<ActivityModel> data;
  final PaginationModel pagination;
}
