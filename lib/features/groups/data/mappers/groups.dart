import 'package:splittr/features/groups/data/models/groups_model.dart';
import 'package:splittr/features/groups/domain/entities/groups.dart';

extension GroupModelX on GroupModel {
  Group toDomain() => Group(
    id: id,
    name: name ?? 'Unnamed Group',
    description: description ?? '',
    inviteCode: inviteCode ?? '',
    createdBy: createdBy ?? 'Unknown',
  );
}
