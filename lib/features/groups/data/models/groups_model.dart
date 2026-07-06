import 'package:freezed_annotation/freezed_annotation.dart';

part 'groups_model.g.dart';

@JsonSerializable()
class GroupsModel {
  const GroupsModel({
    this.id,
    this.name,
    this.description,
    this.inviteCode,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.archivedAt,
  });

  factory GroupsModel.fromJson(Map<String, dynamic> json) =>
      _$GroupsModelFromJson(json);

  final String? id;
  final String? name;
  final String? description;
  final String? inviteCode;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? archivedAt;

  Map<String, dynamic> toJson() => _$GroupsModelToJson(this);
}
