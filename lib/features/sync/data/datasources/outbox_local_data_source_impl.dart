import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/expenses/data/models/expense_isar_model.dart';
import 'package:splittr/features/friends/data/models/friend_isar_model.dart';
import 'package:splittr/features/groups/data/models/group_isar_model.dart';
import 'package:splittr/features/sync/data/datasources/outbox_local_data_source.dart';
import 'package:splittr/features/sync/data/models/outbox_action_isar_model.dart';

@LazySingleton(as: OutboxLocalDataSource)
final class OutboxLocalDataSourceImpl implements OutboxLocalDataSource {
  OutboxLocalDataSourceImpl(this._isar);

  final Isar _isar;

  @override
  Future<void> enqueue(OutboxActionIsarModel action) async {
    await _isar.writeTxn(() async {
      await _isar.outboxActionIsarModels.put(action);
    });
  }

  @override
  Future<List<OutboxActionIsarModel>> getPendingActions() {
    return _isar.outboxActionIsarModels
        .filter()
        .statusEqualTo(OutboxStatus.pending)
        .sortByCreatedAt()
        .findAll();
  }

  @override
  Stream<List<OutboxActionIsarModel>> watchPendingActions() {
    return _isar.outboxActionIsarModels
        .filter()
        .statusEqualTo(OutboxStatus.pending)
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> markInFlight(String idempotencyKey) async {
    await _isar.writeTxn(() async {
      final action = await _isar.outboxActionIsarModels
          .filter()
          .idempotencyKeyEqualTo(idempotencyKey)
          .findFirst();
      if (action == null) return;
      action
        ..status = OutboxStatus.inFlight
        ..lastAttemptedAt = DateTime.now();
      await _isar.outboxActionIsarModels.put(action);
    });
  }

  @override
  Future<void> markSuccess({
    required String idempotencyKey,
    required String? serverId,
    required String? tempId,
  }) async {
    await _isar.writeTxn(() async {
      // Remap tempId -> serverId in remaining pending outbox payloads.
      if (tempId != null && serverId != null) {
        await _remapInTxn(tempId: tempId, serverId: serverId);
      }
      // Delete the completed action.
      await _isar.outboxActionIsarModels
          .filter()
          .idempotencyKeyEqualTo(idempotencyKey)
          .deleteAll();
    });
  }

  @override
  Future<void> markFailed(String idempotencyKey) async {
    await _isar.writeTxn(() async {
      final action = await _isar.outboxActionIsarModels
          .filter()
          .idempotencyKeyEqualTo(idempotencyKey)
          .findFirst();
      if (action == null) return;
      action
        ..status = OutboxStatus.pending
        ..retryCount = action.retryCount + 1
        ..lastAttemptedAt = DateTime.now();
      await _isar.outboxActionIsarModels.put(action);
    });
  }

  @override
  Future<void> remapTempId({
    required String tempId,
    required String serverId,
  }) async {
    await _isar.writeTxn(() async {
      await _remapInTxn(tempId: tempId, serverId: serverId);
    });
  }

  @override
  Future<void> purgeOrphanedTempRecords() async {
    await _isar.writeTxn(() async {
      final activeActions = await _isar.outboxActionIsarModels
          .filter()
          .statusEqualTo(OutboxStatus.pending)
          .or()
          .statusEqualTo(OutboxStatus.inFlight)
          .findAll();

      final activeTempIds = activeActions
          .map((a) => a.tempId)
          .whereType<String>()
          .toSet();

      // Purge orphaned groups
      final tempGroups = await _isar.groupIsarModels
          .filter()
          .idStartsWith('temp-')
          .findAll();
      final orphanGroups = tempGroups
          .where((g) => !activeTempIds.contains(g.id))
          .map((g) => g.isarId)
          .toList();
      if (orphanGroups.isNotEmpty) {
        await _isar.groupIsarModels.deleteAll(orphanGroups);
      }

      // Purge orphaned friends
      final tempFriends = await _isar.friendIsarModels
          .filter()
          .idStartsWith('temp-')
          .findAll();
      final orphanFriends = tempFriends
          .where((f) => !activeTempIds.contains(f.id))
          .map((f) => f.isarId)
          .toList();
      if (orphanFriends.isNotEmpty) {
        await _isar.friendIsarModels.deleteAll(orphanFriends);
      }

      // Purge orphaned expenses
      final tempExpenses = await _isar.expenseIsarModels
          .filter()
          .idStartsWith('temp-')
          .findAll();
      final orphanExpenses = tempExpenses
          .where((e) => !activeTempIds.contains(e.id))
          .map((e) => e.isarId)
          .toList();
      if (orphanExpenses.isNotEmpty) {
        await _isar.expenseIsarModels.deleteAll(orphanExpenses);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Private helpers — must be called inside an existing writeTxn.
  // ---------------------------------------------------------------------------

  Future<void> _remapInTxn({
    required String tempId,
    required String serverId,
  }) async {
    // 1. Pending outbox actions: replace tempId in payloads and tempId field.
    final pending = await _isar.outboxActionIsarModels
        .filter()
        .statusEqualTo(OutboxStatus.pending)
        .findAll();

    final updated = pending
        .where((a) => a.payloadJson.contains(tempId) || a.tempId == tempId)
        .map((a) {
          if (a.tempId == tempId) {
            a.tempId = serverId;
          }
          a.payloadJson = a.payloadJson.replaceAll(tempId, serverId);
          return a;
        })
        .toList();

    if (updated.isNotEmpty) {
      await _isar.outboxActionIsarModels.putAll(updated);
    }

    // 2. Groups cache: replace or delete optimistic group.
    final tempGroup = await _isar.groupIsarModels
        .filter()
        .idEqualTo(tempId)
        .findFirst();
    if (tempGroup != null) {
      final existingServerGroup = await _isar.groupIsarModels
          .filter()
          .idEqualTo(serverId)
          .findFirst();
      if (existingServerGroup != null) {
        await _isar.groupIsarModels.delete(tempGroup.isarId);
      } else {
        tempGroup.id = serverId;
        await _isar.groupIsarModels.put(tempGroup);
      }
    }

    // 3. Friends cache: replace or delete optimistic friend.
    final tempFriend = await _isar.friendIsarModels
        .filter()
        .idEqualTo(tempId)
        .findFirst();
    if (tempFriend != null) {
      final existingServerFriend = await _isar.friendIsarModels
          .filter()
          .idEqualTo(serverId)
          .findFirst();
      if (existingServerFriend != null) {
        await _isar.friendIsarModels.delete(tempFriend.isarId);
      } else {
        tempFriend.id = serverId;
        await _isar.friendIsarModels.put(tempFriend);
      }
    }

    // 4. Expenses cache: replace or delete optimistic expense.
    final tempExpense = await _isar.expenseIsarModels
        .filter()
        .idEqualTo(tempId)
        .findFirst();
    if (tempExpense != null) {
      final existingServerExpense = await _isar.expenseIsarModels
          .filter()
          .idEqualTo(serverId)
          .findFirst();
      if (existingServerExpense != null) {
        await _isar.expenseIsarModels.delete(tempExpense.isarId);
      } else {
        tempExpense.id = serverId;
        await _isar.expenseIsarModels.put(tempExpense);
      }
    }

    // 5. If a group was remapped, also remap any expenses referencing
    // tempId as groupId.
    final expensesInGroup = await _isar.expenseIsarModels
        .filter()
        .groupIdEqualTo(tempId)
        .findAll();
    if (expensesInGroup.isNotEmpty) {
      for (final exp in expensesInGroup) {
        exp.groupId = serverId;
      }
      await _isar.expenseIsarModels.putAll(expensesInGroup);
    }
  }
}
