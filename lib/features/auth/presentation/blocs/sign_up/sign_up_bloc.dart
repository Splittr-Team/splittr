import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/auth/domain/usecases/sign_up_with_email_usecase.dart';

part 'sign_up_bloc.freezed.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

@injectable
class SignUpBloc extends BaseBloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._signUpWithEmailUseCase)
    : super(const SignUpState.initial(store: SignUpStateStore()));

  final SignUpWithEmailUseCase _signUpWithEmailUseCase;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_NameChanged>(_onNameChanged);
    on<_EmailChanged>(_onEmailChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<_SignUpClicked>(_onSignUpClicked);
  }

  FutureOr<void> _onStarted(_Started event, Emitter<SignUpState> emit) {}

  FutureOr<void> _onNameChanged(_NameChanged event, Emitter<SignUpState> emit) {
    emit(
      SignUpState.onNameChange(
        store: state.store.copyWith(name: Name(event.name)),
      ),
    );
  }

  FutureOr<void> _onEmailChanged(
    _EmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      SignUpState.onEmailChange(
        store: state.store.copyWith(emailAddress: EmailAddress(event.email)),
      ),
    );
  }

  FutureOr<void> _onPasswordChanged(
    _PasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      SignUpState.onPasswordChange(
        store: state.store.copyWith(password: Password(event.password)),
      ),
    );
  }

  FutureOr<void> _onConfirmPasswordChanged(
    _ConfirmPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      SignUpState.onConfirmPasswordChange(
        store: state.store.copyWith(
          confirmPassword: Password(event.confirmPassword),
        ),
      ),
    );
  }

  FutureOr<void> _onSignUpClicked(
    _,
    Emitter<SignUpState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _signUpWithEmailUseCase.call(
      SignUpWithEmailParams(
        name: state.store.name?.getOrElse('') ?? '',
        email: state.store.emailAddress?.getOrElse('') ?? '',
        password: state.store.password?.getOrElse('') ?? '',
      ),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (user) => emit(
        SignUpState.onSignUpSuccess(
          store: state.store.copyWith(loading: false),
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const SignUpEvent.started());
  }

  void nameChanged({required String name}) {
    add(SignUpEvent.nameChanged(name: name));
  }

  void emailChanged({required String email}) {
    add(SignUpEvent.emailChanged(email: email));
  }

  void passwordChanged({required String password}) {
    add(SignUpEvent.passwordChanged(password: password));
  }

  void confirmPasswordChanged({required String confirmPassword}) {
    add(SignUpEvent.confirmPasswordChanged(confirmPassword: confirmPassword));
  }

  void signUpClicked() {
    add(const SignUpEvent.signUpClicked());
  }
}
