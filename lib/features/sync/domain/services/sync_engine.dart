import 'package:sky_architecture/sky_architecture.dart';

abstract interface class SyncEngine {
  FutureEitherFailure<Unit> pullSync({int limit = 100});
}
