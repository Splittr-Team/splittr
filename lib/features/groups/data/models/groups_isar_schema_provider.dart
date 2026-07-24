import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/groups/data/models/group_isar_model.dart';

class GroupsIsarSchemaProvider implements IsarSchemaProvider {
  const GroupsIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    GroupIsarModelSchema,
    PaginationMetadataIsarModelSchema,
  ];
}
