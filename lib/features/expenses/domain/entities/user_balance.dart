import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_balance.freezed.dart';

@freezed
class UserBalance with _$UserBalance {
  const UserBalance({
    required this.userId,
    required this.userName,
    required this.netBalance,
  });

  @override
  final String userId;
  @override
  final String userName;
  @override
  final num netBalance;
}
