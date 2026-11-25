part of 'profile_bloc.dart';

@freezed
sealed class ProfileState extends BaseState with _$ProfileState {
  const ProfileState._();

  const factory ProfileState.initial({required ProfileStateStore store}) =
      Initial;

  const factory ProfileState.changeLoaderState({
    required ProfileStateStore store,
  }) = ChangeLoaderState;

  const factory ProfileState.onFailure({
    required ProfileStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory ProfileState.onProfileDataLoaded({
    required ProfileStateStore store,
  }) = OnProfileDataLoaded;

  const factory ProfileState.onProfileUpdated({
    required ProfileStateStore store,
  }) = OnProfileUpdated;

  const factory ProfileState.onDraftChanged({
    required ProfileStateStore store,
  }) = OnDraftChanged;

  @override
  BaseState getFailureState({required Failure failure}) =>
      ProfileState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      ProfileState.changeLoaderState(store: store.copyWith(loading: loading));
}

@freezed
class ProfileStateStore with _$ProfileStateStore {
  const ProfileStateStore({
    this.loading = false,
    this.isEditMode = false,
    this.profile,
    this.settings,
    this.draftName,
    this.draftCurrency,
  });

  @override
  final bool loading;
  @override
  final bool isEditMode;
  @override
  final Profile? profile;
  @override
  final UserSettings? settings;
  @override
  final String? draftName;
  @override
  final String? draftCurrency;

  bool get hasChanges =>
      (draftName?.trim() != (profile?.name ?? '')) ||
      (draftCurrency?.trim() != (profile?.defaultCurrency ?? 'USD'));

  bool get isFormValid =>
      (draftName?.trim().isNotEmpty ?? false) &&
      (draftCurrency?.trim().isNotEmpty ?? false);

  bool get canSave => !loading && isFormValid && hasChanges;
}
