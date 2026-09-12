/// Coordinates when to trigger sync and outbox flush based on app lifecycle
/// and network availability.
abstract interface class SyncCoordinator {
  /// Start listening to app lifecycle events and schedule periodic sync.
  void start();

  /// Stop all listeners and cancel timers.
  void stop();

  /// Trigger a full pull sync + outbox flush immediately.
  Future<void> syncNow();
}
