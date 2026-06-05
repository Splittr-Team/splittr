part of 'login_bloc.dart';

@freezed
class LoginEvent extends BaseEvent with _$LoginEvent {
  const LoginEvent._();

  const factory LoginEvent.started() = _Started;
}
