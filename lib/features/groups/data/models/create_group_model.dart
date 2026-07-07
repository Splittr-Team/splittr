import 'package:json_annotation/json_annotation.dart';

part 'create_group_model.g.dart';

@JsonSerializable(createFactory: false)
class CreateGroupModel {
  const CreateGroupModel({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  Map<String, dynamic> toJson() => _$CreateGroupModelToJson(this);
}
