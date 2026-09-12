import 'package:splittr/features/sync/data/models/outbox_action_isar_model.dart';

abstract interface class OutboxLocalDataSource {
  /// Queue a new mutation action to the outbox.
  Future<void> enqueue(OutboxActionIsarModel action);

  /// Fetch all [OutboxStatus.pending] actions ordered by
  /// [OutboxActionIsarModel.createdAt].
  Future<List<OutboxActionIsarModel>> getPendingActions();

  /// Mark an action as in-flight.
  Future<void> markInFlight(String idempotencyKey);

  /// Mark success: store [serverId], clear [tempId] reference from payloads
  /// of subsequent pending actions, and delete this action from the outbox.
  Future<void> markSuccess({
    required String idempotencyKey,
    required String? serverId,
    required String? tempId,
  });

  /// Increment retry count and reset to pending status.
  Future<void> markFailed(String idempotencyKey);

  /// Replace all occurrences of [tempId] with [serverId] in the
  /// `payloadJson` of remaining pending actions.
  Future<void> remapTempId({
    required String tempId,
    required String serverId,
  });

  /// Watch all pending actions (fires immediately).
  Stream<List<OutboxActionIsarModel>> watchPendingActions();

  /// Purges any optimistic entities (groups, friends, expenses) with `temp-`
  /// IDs that have no corresponding pending or in-flight outbox action.
  Future<void> purgeOrphanedTempRecords();
}
