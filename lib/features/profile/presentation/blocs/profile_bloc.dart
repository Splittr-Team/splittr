import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/profile/domain/entities/profile.dart';
import 'package:splittr/features/profile/domain/entities/user_settings.dart';
import 'package:splittr/features/profile/domain/usecases/get_profile_settings_usecase.dart';
import 'package:splittr/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:splittr/features/profile/domain/usecases/update_avatar_usecase.dart';
import 'package:splittr/features/profile/domain/usecases/update_profile_settings_usecase.dart';
import 'package:splittr/features/profile/domain/usecases/update_profile_usecase.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

@injectable
final class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState, NoParams> {
  ProfileBloc(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._updateAvatarUseCase,
    this._getProfileSettingsUseCase,
    this._updateProfileSettingsUseCase,
  ) : super(const ProfileState.initial(store: ProfileStateStore()));

  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateAvatarUseCase _updateAvatarUseCase;
  final GetProfileSettingsUseCase _getProfileSettingsUseCase;
  final UpdateProfileSettingsUseCase _updateProfileSettingsUseCase;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_EditModeToggled>(_onEditModeToggled);
    on<_NameChanged>(_onNameChanged);
    on<_CurrencyChanged>(_onCurrencyChanged);
    on<_UpdateProfile>(_onUpdateProfile);
    on<_UpdateAvatar>(_onUpdateAvatar);
    on<_UpdateSettings>(_onUpdateSettings);
  }

  void _onEditModeToggled(
    _EditModeToggled event,
    Emitter<ProfileState> emit,
  ) {
    final enteringEdit = !state.store.isEditMode;
    emit(
      ProfileState.onProfileDataLoaded(
        store: state.store.copyWith(
          isEditMode: enteringEdit,
          draftName: enteringEdit ? (state.store.profile?.name ?? '') : null,
          draftCurrency: enteringEdit
              ? (state.store.profile?.defaultCurrency ?? 'USD')
              : null,
        ),
      ),
    );
  }

  void _onNameChanged(
    _NameChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      ProfileState.onDraftChanged(
        store: state.store.copyWith(draftName: event.name),
      ),
    );
  }

  void _onCurrencyChanged(
    _CurrencyChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      ProfileState.onDraftChanged(
        store: state.store.copyWith(draftCurrency: event.currency),
      ),
    );
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<ProfileState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final profileResult = await _getProfileUseCase.call(noParams);
    final settingsResult = await _getProfileSettingsUseCase.call(noParams);

    var currentStore = state.store.copyWith(loading: false);

    profileResult.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (profile) {
        currentStore = currentStore.copyWith(profile: profile);
      },
    );

    settingsResult.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (settings) {
        currentStore = currentStore.copyWith(settings: settings);
      },
    );

    emit(ProfileState.onProfileDataLoaded(store: currentStore));
  }

  FutureOr<void> _onUpdateProfile(
    _UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.store.canSave) return;

    changeLoadingState(emit: emit, loading: true);

    final result = await _updateProfileUseCase.call(
      UpdateProfileParams(
        name: state.store.draftName?.trim(),
        defaultCurrency: state.store.draftCurrency?.trim(),
      ),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (profile) => emit(
        ProfileState.onProfileUpdated(
          store: state.store.copyWith(
            loading: false,
            isEditMode: false,
            draftName: null,
            draftCurrency: null,
            profile: profile,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onUpdateAvatar(
    _UpdateAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _updateAvatarUseCase.call(
      UpdateAvatarParams(file: event.file),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (profile) => emit(
        ProfileState.onProfileUpdated(
          store: state.store.copyWith(
            loading: false,
            profile: profile,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onUpdateSettings(
    _UpdateSettings event,
    Emitter<ProfileState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _updateProfileSettingsUseCase.call(
      UpdateProfileSettingsParams(
        autoAcceptFriendRequests: event.autoAcceptFriendRequests,
      ),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (settings) => emit(
        ProfileState.onProfileDataLoaded(
          store: state.store.copyWith(loading: false, settings: settings),
        ),
      ),
    );
  }

  @override
  void started(NoParams params) {
    add(const ProfileEvent.started());
  }

  void editModeToggled() {
    add(const ProfileEvent.editModeToggled());
  }

  void nameChanged(String name) {
    add(ProfileEvent.nameChanged(name));
  }

  void currencyChanged(String currency) {
    add(ProfileEvent.currencyChanged(currency));
  }

  void updateProfile() {
    add(const ProfileEvent.updateProfile());
  }

  void updateAvatar(File file) {
    add(ProfileEvent.updateAvatar(file));
  }

  void updateSettings({bool? autoAcceptFriendRequests}) {
    add(
      ProfileEvent.updateSettings(
        autoAcceptFriendRequests: autoAcceptFriendRequests,
      ),
    );
  }
}
