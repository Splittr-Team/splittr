import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'sync_metadata_isar_model.g.dart';

@collection
class SyncMetadataIsarModel with IsarCacheable {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String key = 'sync_watermark';

  int groupsVersion = 0;
  int friendsVersion = 0;
  int expensesVersion = 0;
}
