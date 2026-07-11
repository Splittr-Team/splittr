import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/auth/domain/usecases/login_with_email_usecase.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc(this._loginWithEmailUseCase)
    : super(const LoginState.initial(store: LoginStateStore()));

  final LoginWithEmailUseCase _loginWithEmailUseCase;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_EmailChanged>(_onEmailChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_LoginClicked>(_onLoginClicked);
  }

  FutureOr<void> _onStarted(_Started event, Emitter<LoginState> emit) {}

  FutureOr<void> _onEmailChanged(
    _EmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      LoginState.onEmailChange(
        store: state.store.copyWith(emailAddress: EmailAddress(event.email)),
      ),
    );
  }

  FutureOr<void> _onPasswordChanged(
    _PasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      LoginState.onPasswordChange(
        store: state.store.copyWith(password: Password(event.password)),
      ),
    );
  }

  FutureOr<void> _onLoginClicked(
    _LoginClicked event,
    Emitter<LoginState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _loginWithEmailUseCase.call(
      LoginWithEmailParams(
        email: state.store.emailAddress?.getOrElse('') ?? '',
        password: state.store.password?.getOrElse('') ?? '',
      ),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) => emit(
        LoginState.onLoginSuccess(
          store: state.store.copyWith(loading: false),
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const LoginEvent.started());
  }

  void emailChanged({required String email}) {
    add(LoginEvent.emailChanged(email: email));
  }

  void passwordChanged({required String password}) {
    add(LoginEvent.passwordChanged(password: password));
  }

  void loginClicked() {
    add(const LoginEvent.loginClicked());
  }
}
