import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:splittr/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc(this._checkAuthStatusUseCase, this._logoutUseCase)
    : super(const AuthState.initial(store: AuthStateStore()));

  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LogoutUseCase _logoutUseCase;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_AuthStatusChecked>(_onAuthStatusChecked);
    on<_LoggedOut>(_onLoggedOut);
  }

  FutureOr<void> _onStarted(_Started event, Emitter<AuthState> emit) {}

  FutureOr<void> _onAuthStatusChecked(
    _AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    final userOrFailure = await _checkAuthStatusUseCase.call(noParams);

    userOrFailure.fold(
      (failure) => emit(AuthState.onUserUnauthenticated(store: state.store)),
      (user) => emit(AuthState.onUserAuthenticated(store: state.store)),
    );
  }

  FutureOr<void> _onLoggedOut(_LoggedOut event, Emitter<AuthState> emit) async {
    await _logoutUseCase.call(noParams);

    emit(const AuthState.onLogout(store: AuthStateStore()));
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const AuthEvent.started());
  }

  void authStatusChecked() {
    add(const AuthEvent.authStatusChecked());
  }

  void loggedOut() {
    add(const AuthEvent.loggedOut());
  }
}
