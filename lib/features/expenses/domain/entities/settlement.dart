import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement.freezed.dart';

@freezed
class Settlement with _$Settlement {
  const Settlement({
    required this.amount,
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserId,
    required this.toUserName,
  });

  @override
  final num amount;
  @override
  final String fromUserId;
  @override
  final String fromUserName;
  @override
  final String toUserId;
  @override
  final String toUserName;
}
