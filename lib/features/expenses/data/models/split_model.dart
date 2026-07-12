import 'package:json_annotation/json_annotation.dart';

part 'split_model.g.dart';

@JsonSerializable()
class SplitModel {
  const SplitModel({
    required this.userId,
    required this.amount,
    required this.splitType,
    required this.name,
    this.splitValue,
    this.email,
    this.phone,
  });

  factory SplitModel.fromJson(Map<String, dynamic> json) =>
      _$SplitModelFromJson(json);

  final String userId;
  final num amount;
  final String splitType;
  final num? splitValue;
  final String name;
  final String? email;
  final String? phone;
}
