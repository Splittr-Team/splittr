import 'package:json_annotation/json_annotation.dart';

part 'group_preview_model.g.dart';

@JsonSerializable()
class GroupPreviewModel {
  const GroupPreviewModel({
    required this.name,
    required this.memberCount,
    required this.creatorName,
    required this.description,
  });

  factory GroupPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$GroupPreviewModelFromJson(json);

  final String name;

  final String description;

  final int memberCount;

  final String creatorName;
}
