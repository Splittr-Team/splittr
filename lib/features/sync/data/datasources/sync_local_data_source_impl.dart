import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/expenses/data/mappers/expense_mappers.dart';
import 'package:splittr/features/expenses/data/models/expense_isar_model.dart';
import 'package:splittr/features/friends/data/mappers/friend_mappers.dart';
import 'package:splittr/features/friends/data/models/friend_isar_model.dart';
import 'package:splittr/features/groups/data/mappers/group_model_to_isar.dart';
import 'package:splittr/features/groups/data/models/group_isar_model.dart';
import 'package:splittr/features/sync/data/datasources/sync_local_data_source.dart';
import 'package:splittr/features/sync/data/models/sync_metadata_isar_model.dart';
import 'package:splittr/features/sync/data/models/sync_response_model.dart';

@LazySingleton(as: SyncLocalDataSource)
final class SyncLocalDataSourceImpl implements SyncLocalDataSource {
  SyncLocalDataSourceImpl(this._isar);

  final Isar _isar;

  @override
  Future<SyncMetadataIsarModel?> getMetadata() {
    return _isar.syncMetadataIsarModels
        .filter()
        .keyEqualTo('sync_watermark')
        .findFirst();
  }

  @override
  Stream<SyncMetadataIsarModel?> watchMetadata() {
    return _isar.syncMetadataIsarModels
        .filter()
        .keyEqualTo('sync_watermark')
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getMetadata());
  }

  @override
  Future<void> saveMetadata(SyncMetadataIsarModel metadata) async {
    await _isar.writeTxn(() async {
      await _isar.syncMetadataIsarModels.put(metadata);
    });
  }

  @override
  Future<void> applyDelta(SyncResponseModel delta) async {
    await _isar.writeTxn(() async {
      // --- Tombstones ---
      for (final id in delta.friends.deletedIds) {
        await _isar.friendIsarModels.filter().idEqualTo(id).deleteAll();
      }
      for (final id in delta.groups.deletedIds) {
        await _isar.groupIsarModels.filter().idEqualTo(id).deleteAll();
      }
      for (final id in delta.expenses.deletedIds) {
        await _isar.expenseIsarModels.filter().idEqualTo(id).deleteAll();
      }

      // --- Upserts ---
      if (delta.friends.updated.isNotEmpty) {
        await _isar.friendIsarModels.putAll(delta.friends.updated.toIsar());
      }
      if (delta.groups.updated.isNotEmpty) {
        await _isar.groupIsarModels.putAll(delta.groups.updated.toIsar());
      }
      if (delta.expenses.updated.isNotEmpty) {
        await _isar.expenseIsarModels.putAll(delta.expenses.updated.toIsar());
      }

      // --- Watermark update ---
      final meta =
          await _isar.syncMetadataIsarModels
                    .filter()
                    .keyEqualTo('sync_watermark')
                    .findFirst() ??
                (SyncMetadataIsarModel()..key = 'sync_watermark')
            ..friendsVersion = delta.friends.newVersion
            ..groupsVersion = delta.groups.newVersion
            ..expensesVersion = delta.expenses.newVersion
            ..lastSyncedAt = DateTime.now();

      await _isar.syncMetadataIsarModels.put(meta);
    });
  }
}
