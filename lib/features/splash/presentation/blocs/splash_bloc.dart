import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

@injectable
final class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState.initial(store: SplashStateStore()));

  final Completer<bool> _userAuthCompleter = Completer<bool>();

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  Future<void> _onStarted(_, Emitter<SplashState> emit) async {
    emit(SplashState.onCheckAuthStatus(store: state.store));

    final (_, userAuthenticted) = await (
      Future<void>.delayed(const Duration(seconds: 3)),
      _userAuthCompleter.future,
    ).wait;

    if (userAuthenticted) {
      emit(SplashState.onUserAuthorize(store: state.store));
    } else {
      emit(SplashState.onUserUnauthorize(store: state.store));
    }
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const SplashEvent.started());
  }

  void userAuthorized() {
    _userAuthCompleter.complete(true);
  }

  void userUnauthorized() {
    _userAuthCompleter.complete(false);
  }
}
