import 'package:splittr/features/sync/data/models/sync_metadata_isar_model.dart';
import 'package:splittr/features/sync/data/models/sync_response_model.dart';

abstract interface class SyncLocalDataSource {
  Future<SyncMetadataIsarModel?> getMetadata();

  Stream<SyncMetadataIsarModel?> watchMetadata();

  Future<void> saveMetadata(SyncMetadataIsarModel metadata);

  Future<void> applyDelta(SyncResponseModel delta);
}
