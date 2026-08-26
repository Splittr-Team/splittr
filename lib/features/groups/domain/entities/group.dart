import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';

part 'group.freezed.dart';

@freezed
class Group with _$Group {
  const Group({
    this.id,
    this.name,
    this.description,
    this.inviteCode,
    this.inviteCodeExpiresAt,
    this.requireAdminApproval = false,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.members = const [],
  });

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? inviteCode;
  @override
  final DateTime? inviteCodeExpiresAt;
  @override
  final bool requireAdminApproval;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final List<Member> members;
}
