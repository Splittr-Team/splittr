import 'package:freezed_annotation/freezed_annotation.dart';

part 'groups.freezed.dart';

@freezed
class Group with _$Group {
  const Group({
    this.id,
    this.name,
    this.description,
    this.inviteCode,
    this.createdBy,
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
}
