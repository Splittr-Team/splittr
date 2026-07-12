import 'package:json_annotation/json_annotation.dart';

part 'input_split_payload.g.dart';

@JsonSerializable()
class InputSplitPayload {
  const InputSplitPayload({
    required this.userId,
    this.amount,
    this.percentage,
  });

  final String userId;
  final num? amount;
  final num? percentage;

  Map<String, dynamic> toJson() => _$InputSplitPayloadToJson(this);
}
