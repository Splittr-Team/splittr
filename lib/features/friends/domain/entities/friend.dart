import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend.freezed.dart';

@freezed
class Friend with _$Friend {
  const Friend({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.defaultCurrency,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.actionUserId,
  });

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? defaultCurrency;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final FriendshipStatus? status;
  @override
  final String? actionUserId;
}

enum FriendshipStatus {
  pending,
  accepted,
  declined,
  blocked,
}
