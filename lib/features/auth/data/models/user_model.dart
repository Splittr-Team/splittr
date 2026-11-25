import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.defaultCurrency,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? defaultCurrency;
}
