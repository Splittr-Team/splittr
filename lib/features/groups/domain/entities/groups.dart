import 'package:freezed_annotation/freezed_annotation.dart';

part 'groups.freezed.dart';

@freezed
class Groups with _$Groups {
  const Groups({
    this.id,
    this.name,
    this.description,
    this.inviteCode,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.archivedAt,
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
  final String? createdBy;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? archivedAt;
}
