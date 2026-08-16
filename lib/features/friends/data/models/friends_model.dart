import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/core/network/pagination_model.dart';
import 'package:splittr/features/friends/data/models/friend_model.dart';

part 'friends_model.g.dart';

@JsonSerializable()
class FriendsModel {
  const FriendsModel({
    required this.data,
    required this.pagination,
  });

  factory FriendsModel.fromJson(Map<String, dynamic> json) =>
      _$FriendsModelFromJson(json);

  final List<FriendModel> data;
  final PaginationModel pagination;
}
