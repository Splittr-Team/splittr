part of 'global_bloc.dart';

@freezed
class GlobalEvent extends BaseEvent with _$GlobalEvent {
  const GlobalEvent._();

  const factory GlobalEvent.started() = _Started;

  const factory GlobalEvent.userUpdated({required User user}) = _UserUpdated;

  const factory GlobalEvent.themeChanged({
    required ThemeMode themeMode,
  }) = _ThemeChanged;
}
