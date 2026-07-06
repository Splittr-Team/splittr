import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:splittr/features/auth/domain/usecases/get_auth_state_changes_usecase.dart';
import 'package:splittr/features/auth/domain/usecases/login_as_guest_usecase.dart';
import 'package:splittr/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc(
    this._checkAuthStatusUseCase,
    this._logoutUseCase,
    this._getAuthStateChangesUseCase,
    this._loginAsGuestUseCase,
  ) : super(const AuthState.initial(store: AuthStateStore())) {
    _authSubscription = _getAuthStateChangesUseCase.call(noParams).listen((
      result,
    ) {
      result.fold(
        (_) {},
        (userOption) => add(AuthEvent.userSessionChanged(userOption)),
      );
    });
  }

  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetAuthStateChangesUseCase _getAuthStateChangesUseCase;
  final LoginAsGuestUseCase _loginAsGuestUseCase;
  StreamSubscription<Either<Failure, Option<User>>>? _authSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_LoggedOut>(_onLoggedOut);
    on<_LoginAsGuest>(_onLoginAsGuest);
    on<_UserSessionChanged>(_onUserSessionChanged);
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

    result.fold(
      (failure) => emit(
        AuthState.onFailure(store: state.store, failure: failure),
      ),
      (_) {},
    );
  }

  void _onUserSessionChanged(
    _UserSessionChanged event,
    Emitter<AuthState> emit,
  ) {
    event.userOption.fold(
      () => emit(AuthState.onUserUnauthenticated(store: state.store)),
      (user) {
        if (user.id == 'guest') {
          emit(AuthState.guest(store: state.store));
        } else {
          emit(AuthState.authenticated(store: state.store, user: user));
        }
      },
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const AuthEvent.started());
  }

  void loggedOut() {
    add(const AuthEvent.loggedOut());
  }

  void loginAsGuest() {
    add(const AuthEvent.loginAsGuest());
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}
