import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    this.id,
    this.firebaseUid,
    this.name,
    this.email,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String? id;
  final String? firebaseUid;
  final String? name;
  final String? email;
  final String? phone;
}
