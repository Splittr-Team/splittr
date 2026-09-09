import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/sync/data/datasources/outbox_local_data_source.dart';
import 'package:splittr/features/sync/data/models/outbox_action_isar_model.dart';
import 'package:splittr/features/sync/domain/services/outbox_worker.dart';

@LazySingleton(as: OutboxWorker)
final class OutboxWorkerImpl implements OutboxWorker {
  OutboxWorkerImpl(
    this._apiCallHandler,
    this._outboxLocalDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final OutboxLocalDataSource _outboxLocalDataSource;
  final Mutex _flushLock = Mutex();

  /// Registry mapping actionType -> dispatcher.
  /// Populated by callers (e.g. feature repositories) at app startup via
  /// [registerDispatcher].
  final Map<String, ActionDispatcher> _dispatchers = {};

  @override
  void registerDispatcher(String actionType, ActionDispatcher dispatcher) {
    _dispatchers[actionType] = dispatcher;
  }

  @override
  FutureEitherFailure<Unit> flush() {
    return _flushLock.protect(() async {
      final pending = await _outboxLocalDataSource.getPendingActions();

      for (final action in pending) {
        final result = await _dispatchAction(action);
        if (result.isLeft()) {
          // Stop flushing on unrecoverable error; will retry on next flush.
          return result;
        }
      }

      await _outboxLocalDataSource.purgeOrphanedTempRecords();

      return const Right(unit);
    });
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  FutureEitherFailure<Unit> _dispatchAction(
    OutboxActionIsarModel action,
  ) async {
    final dispatcher = _dispatchers[action.actionType];
    if (dispatcher == null) {
      // Unknown action type — remove it so it doesn't block the queue.
      await _outboxLocalDataSource.markSuccess(
        idempotencyKey: action.idempotencyKey,
        serverId: null,
        tempId: null,
      );
      return const Right(unit);
    }

    await _outboxLocalDataSource.markInFlight(action.idempotencyKey);

    final payload = jsonDecode(action.payloadJson) as Map<String, dynamic>;

    final result = await _apiCallHandler.handle(
      () => dispatcher(payload, action.idempotencyKey),
    );

    return result.fold(
      (failure) async {
        await _outboxLocalDataSource.markFailed(action.idempotencyKey);
        return Left(failure);
      },
      (serverId) async {
        await _outboxLocalDataSource.markSuccess(
          idempotencyKey: action.idempotencyKey,
          serverId: serverId,
          tempId: action.tempId,
        );
        return const Right(unit);
      },
    );
  }
}
