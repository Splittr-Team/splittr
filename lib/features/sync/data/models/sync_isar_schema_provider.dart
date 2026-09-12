import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/sync/data/models/outbox_action_isar_model.dart';
import 'package:splittr/features/sync/data/models/sync_metadata_isar_model.dart';

class SyncIsarSchemaProvider implements IsarSchemaProvider {
  const SyncIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    SyncMetadataIsarModelSchema,
    OutboxActionIsarModelSchema,
  ];
}
