part of 'add_friend_bloc.dart';

@freezed
class AddFriendEvent extends BaseEvent with _$AddFriendEvent {
  const AddFriendEvent._();

  const factory AddFriendEvent.started() = _Started;

  const factory AddFriendEvent.emailOrPhoneChanged({
    required String emailOrPhone,
  }) = _EmailOrPhoneChanged;

  const factory AddFriendEvent.submitButtonClicked() = _SubmitButtonClicked;
}
