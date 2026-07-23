import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/features/groups/data/models/member_model.dart';

part 'group_model.g.dart';

@JsonSerializable()
class GroupModel {
  const GroupModel({
    this.id,
    this.name,
    this.description,
    this.inviteCode,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.members,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  final String? id;
  final String? name;
  final String? description;
  final String? inviteCode;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<MemberModel>? members;
}
