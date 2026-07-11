import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:splittr/features/auth/domain/usecases/login_as_guest_usecase.dart';
import 'package:splittr/features/auth/domain/usecases/logout_usecase.dart';
import 'package:splittr/features/auth/domain/usecases/watch_auth_state_usecase.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc(
    this._checkAuthStatusUseCase,
    this._logoutUseCase,
    this._watchAuthStateUseCase,
    this._loginAsGuestUseCase,
  ) : super(const AuthState.loading()) {
    _authStateStreamSubscription = _watchAuthStateUseCase
        .call(noParams)
        .listen(authStateChanged);
  }

  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LogoutUseCase _logoutUseCase;
  final WatchAuthStateUseCase _watchAuthStateUseCase;
  final LoginAsGuestUseCase _loginAsGuestUseCase;

  StreamSubscription<Option<User>>? _authStateStreamSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_LoggedOut>(_onLoggedOut);
    on<_LoginAsGuest>(_onLoginAsGuest);
    on<_AuthStateChanged>(_onAuthStateChanged);
  }

  FutureOr<void> _onStarted(_Started event, Emitter<AuthState> emit) async {
    await _checkAuthStatusUseCase.call(noParams);
  }

  FutureOr<void> _onLoggedOut(_LoggedOut event, Emitter<AuthState> emit) async {
    await _logoutUseCase.call(noParams);
  }

  FutureOr<void> _onLoginAsGuest(
    _LoginAsGuest event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _loginAsGuestUseCase.call(noParams);

    if (result case Left(value: final failure)) {
      emit(AuthState.onFailure(failure: failure));
    }
  }

  void _onAuthStateChanged(
    _AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    event.userOption.fold(
      () => emit(const AuthState.onUserUnauthenticated()),
      (user) => user.id == 'guest'
          ? emit(const AuthState.guest())
          : emit(AuthState.onUserAuthenticated(user: user)),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const AuthEvent.started());
  }

  @override
  Future<void> close() async {
    await _authStateStreamSubscription?.cancel();
    return super.close();
  }

  void loggedOut() {
    add(const AuthEvent.loggedOut());
  }

  void loginAsGuest() {
    add(const AuthEvent.loginAsGuest());
  }

  void authStateChanged(Option<User> userOption) {
    add(AuthEvent.authStateChanged(userOption));
  }
}
