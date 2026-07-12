import 'package:json_annotation/json_annotation.dart';

part 'user_balance_model.g.dart';

@JsonSerializable()
class UserBalanceModel {
  const UserBalanceModel({
    required this.userId,
    required this.userName,
    required this.netBalance,
  });

  factory UserBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$UserBalanceModelFromJson(json);

  final String userId;
  final String userName;
  final num netBalance;
}
