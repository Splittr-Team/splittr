import 'package:json_annotation/json_annotation.dart';

part 'update_user_payload.g.dart';

@JsonSerializable()
class UpdateUserPayload {
  const UpdateUserPayload({
    this.name,
    this.defaultCurrency,
  });

  final String? name;
  final String? defaultCurrency;

  Map<String, dynamic> toJson() => _$UpdateUserPayloadToJson(this);
}
