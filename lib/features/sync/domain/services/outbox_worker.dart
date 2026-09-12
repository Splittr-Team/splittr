import 'package:sky_architecture/sky_architecture.dart';

abstract interface class OutboxWorker {
  /// Flush all pending outbox actions sequentially.
  /// Returns [Right(unit)] when queue is empty or fully drained.
  FutureEitherFailure<Unit> flush();
}
