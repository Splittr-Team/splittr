import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/core/network/pagination_model.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';

part 'friends_response_model.g.dart';

@JsonSerializable()
class FriendsResponseModel {
  const FriendsResponseModel({
    required this.data,
    required this.pagination,
  });

  factory FriendsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FriendsResponseModelFromJson(json);

  final List<UserModel> data;
  final PaginationModel pagination;
}
