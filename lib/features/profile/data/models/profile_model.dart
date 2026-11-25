import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  const ProfileModel({
    this.id,
    this.email,
    this.name,
    this.avatarUrl,
    this.defaultCurrency,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  final String? id;
  final String? email;
  final String? name;
  final String? avatarUrl;
  final String? defaultCurrency;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
