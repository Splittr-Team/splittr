import 'package:splittr/features/groups/data/models/group_preview_model.dart';
import 'package:splittr/features/groups/domain/entities/group_preview.dart';

extension GroupPreviewModelX on GroupPreviewModel {
  GroupPreview toDomain() => GroupPreview(
    name: name,
    description: description,
    memberCount: memberCount,
    creatorName: creatorName,
    requireAdminApproval: requireAdminApproval ?? false,
  );
}
