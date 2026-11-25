part of 'profile_bloc.dart';

@freezed
class ProfileEvent extends BaseEvent with _$ProfileEvent {
  const ProfileEvent._();

  const factory ProfileEvent.started() = _Started;

  const factory ProfileEvent.editModeToggled() = _EditModeToggled;

  const factory ProfileEvent.nameChanged(String name) = _NameChanged;

  const factory ProfileEvent.currencyChanged(String currency) =
      _CurrencyChanged;

  const factory ProfileEvent.updateProfile() = _UpdateProfile;

  const factory ProfileEvent.updateAvatar(File file) = _UpdateAvatar;

  const factory ProfileEvent.updateSettings({
    bool? autoAcceptFriendRequests,
  }) = _UpdateSettings;
}
