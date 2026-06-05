part of 'signup_bloc.dart';

@freezed
class SignupEvent extends BaseEvent with _$SignupEvent {
  const SignupEvent._();

  const factory SignupEvent.started() = _Started;
}
