import 'package:sky_architecture/sky_architecture.dart';

typedef ActionDispatcher =
    Future<String?> Function(
      Map<String, dynamic> payload,
      String idempotencyKey,
    );

abstract interface class OutboxWorker {
  /// Register a dispatcher for a given [actionType].
  void registerDispatcher(String actionType, ActionDispatcher dispatcher);

  /// Flush all pending outbox actions sequentially.
  /// Returns [Right(unit)] when queue is empty or fully drained.
  FutureEitherFailure<Unit> flush();
}
