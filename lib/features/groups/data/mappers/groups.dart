import 'package:splittr/features/groups/data/models/groups_model.dart';
import 'package:splittr/features/groups/domain/entities/groups.dart';

extension GroupsModelX on GroupsModel {
  Groups toDomain() => Groups(
    id: id,
    name: name ?? 'Unnamed Group',
    description: description ?? '',
    inviteCode: inviteCode ?? '',
    createdBy: createdBy ?? 'Unknown',
    createdAt: createdAt,
    updatedAt: updatedAt,
    archivedAt: archivedAt,
  );
}
