import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';

@freezed
class Member with _$Member {
  const Member({
    this.groupId,
    this.userId,
    this.role,
    this.joinedAt,
    this.name,
    this.email,
    this.phone,
  });

  @override
  final String? groupId;
  @override
  final String? userId;
  // TODO(SKY): add enum
  @override
  final String? role;
  @override
  final String? joinedAt;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? phone;
}
