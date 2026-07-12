import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable()
class GroupModel {
  const GroupModel({
    this.id,
    this.name,
    this.description,
    this.inviteCode,
    this.createdBy,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  final String? id;
  final String? name;
  final String? description;
  final String? inviteCode;
  final String? createdBy;
}
