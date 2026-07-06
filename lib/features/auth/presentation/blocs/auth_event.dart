part of 'auth_bloc.dart';

@freezed
class AuthEvent extends BaseEvent with _$AuthEvent {
  const AuthEvent._();

  const factory AuthEvent.started() = _Started;

  const factory AuthEvent.loggedOut() = _LoggedOut;

  const factory AuthEvent.loginAsGuest() = _LoginAsGuest;

  const factory AuthEvent.userSessionChanged(
    Option<User> userOption,
  ) = _UserSessionChanged;
}
