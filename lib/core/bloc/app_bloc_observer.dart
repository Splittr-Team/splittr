import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_telemetry/sky_telemetry.dart';

/// A custom [BlocObserver] that pipes all BLoC lifecycle events, transitions,
/// and errors to the registered [AppLogger] instances.
class AppBlocObserver extends BlocObserver {
  /// Creates an [AppBlocObserver].
  AppBlocObserver(this.logger);

  /// The unified app logger.
  final AppLogger logger;

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.debug('BLoC Event | ${bloc.runtimeType} | Event: $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.debug(
      'BLoC Change | ${bloc.runtimeType} | '
      '${change.currentState} -> ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.error(
      'BLoC Error | ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
