part of 'sign_up_bloc.dart';

@freezed
class SignUpEvent extends BaseEvent with _$SignUpEvent {
  const SignUpEvent._();

  const factory SignUpEvent.started() = _Started;

  const factory SignUpEvent.nameChanged({
    required String name,
  }) = _NameChanged;

  const factory SignUpEvent.emailChanged({
    required String email,
  }) = _EmailChanged;

  const factory SignUpEvent.passwordChanged({
    required String password,
  }) = _PasswordChanged;

  const factory SignUpEvent.confirmPasswordChanged({
    required String confirmPassword,
  }) = _ConfirmPasswordChanged;

  const factory SignUpEvent.signUpClicked() = _SignUpClicked;

  const factory SignUpEvent.googleSignInClicked() = _GoogleSignInClicked;
}
