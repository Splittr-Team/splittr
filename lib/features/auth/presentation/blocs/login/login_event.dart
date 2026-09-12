part of 'login_bloc.dart';

@freezed
class LoginEvent extends BaseEvent with _$LoginEvent {
  const LoginEvent._();

  const factory LoginEvent.started() = _Started;

  const factory LoginEvent.emailChanged({
    required String email,
  }) = _EmailChanged;

  const factory LoginEvent.passwordChanged({
    required String password,
  }) = _PasswordChanged;

  const factory LoginEvent.loginClicked() = _LoginClicked;

  const factory LoginEvent.googleSignInClicked() = _GoogleSignInClicked;
}
