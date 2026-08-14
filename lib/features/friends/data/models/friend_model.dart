import 'package:json_annotation/json_annotation.dart';

part 'friend_model.g.dart';

@JsonSerializable()
class FriendModel {
  const FriendModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.defaultCurrency,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.actionUserId,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? defaultCurrency;
  final String? createdAt;
  final String? updatedAt;
  final String? status;
  final String? actionUserId;
}
