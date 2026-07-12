import 'package:json_annotation/json_annotation.dart';

part 'settlement_model.g.dart';

@JsonSerializable()
class SettlementModel {
  const SettlementModel({
    required this.amount,
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserId,
    required this.toUserName,
  });

  factory SettlementModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementModelFromJson(json);

  final num amount;
  final String fromUserId;
  final String fromUserName;
  final String toUserId;
  final String toUserName;
}
