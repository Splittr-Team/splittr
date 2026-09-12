import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:splittr/features/sync/domain/services/outbox_worker.dart';
import 'package:splittr/features/sync/domain/services/sync_coordinator.dart';
import 'package:splittr/features/sync/domain/services/sync_engine.dart';

/// How often to run a background sync when the app is in the foreground.
const Duration _kSyncInterval = Duration(minutes: 5);

@LazySingleton(as: SyncCoordinator)
final class SyncCoordinatorImpl
    with WidgetsBindingObserver
    implements SyncCoordinator {
  SyncCoordinatorImpl(
    this._syncEngine,
    this._outboxWorker,
  );

  final SyncEngine _syncEngine;
  final OutboxWorker _outboxWorker;

  Timer? _periodicTimer;
  bool _started = false;

  @override
  void start() {
    if (_started) return;
    _started = true;

    WidgetsBinding.instance.addObserver(this);
    _startPeriodicSync();
  }

  @override
  void stop() {
    if (!_started) return;
    _started = false;

    WidgetsBinding.instance.removeObserver(this);
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  @override
  Future<void> syncNow() async {
    await _syncEngine.pullSync();
    await _outboxWorker.flush();
  }

  // ---------------------------------------------------------------------------
  // WidgetsBindingObserver
  // ---------------------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came to foreground — sync immediately.
      syncNow().ignore();
      // Restart periodic timer so interval resets from now.
      _startPeriodicSync();
    } else if (state == AppLifecycleState.paused) {
      _periodicTimer?.cancel();
      _periodicTimer = null;
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _startPeriodicSync() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(_kSyncInterval, (_) {
      syncNow().ignore();
    });
  }
}
