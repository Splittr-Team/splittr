import 'package:json_annotation/json_annotation.dart';

part 'create_group_model.g.dart';

@JsonSerializable(createFactory: false)
class CreateGroupModel {
  const CreateGroupModel({
    required this.description,
    required this.name,
  });

  final String description;
  final String name;

  Map<String, dynamic> toJson() => _$CreateGroupModelToJson(this);
}
