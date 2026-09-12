part of 'profile_bloc.dart';

@freezed
sealed class ProfileState extends BaseState with _$ProfileState {
  const ProfileState._();

  const factory ProfileState.initial({
    required ProfileStateStore store,
  }) = Initial;

  const factory ProfileState.changeLoaderState({
    required ProfileStateStore store,
  }) = ChangeLoaderState;

  const factory ProfileState.onFailure({
    required ProfileStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory ProfileState.onProfileLoaded({
    required ProfileStateStore store,
  }) = OnProfileLoaded;

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
    this.user,
    this.selectedCurrency = 'INR',
    this.isDarkMode = true,
  });

  @override
  final bool loading;
  @override
  final User? user;
  @override
  final String selectedCurrency;
  @override
  final bool isDarkMode;
}
