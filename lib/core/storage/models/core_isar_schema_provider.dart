import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';

class CoreIsarSchemaProvider implements IsarSchemaProvider {
  const CoreIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    PaginationMetadataIsarModelSchema,
  ];
}
