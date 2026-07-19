import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/core/network/pagination_model.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';

part 'groups_response_model.g.dart';

@JsonSerializable()
class GroupsResponseModel {
  const GroupsResponseModel({
    required this.data,
    required this.pagination,
  });

  factory GroupsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GroupsResponseModelFromJson(json);

  final List<GroupModel> data;
  final PaginationModel pagination;
}
