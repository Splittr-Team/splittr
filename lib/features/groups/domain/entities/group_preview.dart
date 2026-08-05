import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_preview.freezed.dart';

@freezed
class GroupPreview with _$GroupPreview {
  const GroupPreview({
    required this.name,
    required this.memberCount,
    required this.creatorName,
    required this.description,
  });

  @override
  final String name;
  @override
  final String description;
  @override
  final int memberCount;
  @override
  final String creatorName;
}
