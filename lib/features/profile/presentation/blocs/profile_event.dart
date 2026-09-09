part of 'profile_bloc.dart';

@freezed
class ProfileEvent extends BaseEvent with _$ProfileEvent {
  const ProfileEvent._();

  const factory ProfileEvent.started() = _Started;

  const factory ProfileEvent.userUpdated({
    required User? user,
  }) = _UserUpdated;

  const factory ProfileEvent.currencyChanged({
    required String currency,
  }) = _CurrencyChanged;

  const factory ProfileEvent.themeModeToggled({
    required bool isDarkMode,
  }) = _ThemeModeToggled;
}
