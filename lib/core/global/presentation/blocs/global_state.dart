part of 'global_bloc.dart';

@freezed
sealed class GlobalState extends BaseState with _$GlobalState {
  const GlobalState._();

  const factory GlobalState.initial({required GlobalStateStore store}) =
      Initial;

  const factory GlobalState.updatedUser({required GlobalStateStore store}) =
      UpdatedUser;

  const factory GlobalState.changeLoaderState({
    required GlobalStateStore store,
  }) = ChangeLoaderState;

  const factory GlobalState.themeUpdated({
    required GlobalStateStore store,
  }) = ThemeUpdated;

  const factory GlobalState.onFailure({
    required GlobalStateStore store,
    required Failure failure,
  }) = OnFailure;

  @override
  BaseState getFailureState({required Failure failure}) =>
      GlobalState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      GlobalState.changeLoaderState(store: store.copyWith(loading: loading));
}

@freezed
class GlobalStateStore with _$GlobalStateStore {
  const GlobalStateStore({
    this.loading = false,
    this.user,
    this.themeMode = ThemeMode.dark,
  });

  @override
  final bool loading;

  @override
  final User? user;

  @override
  final ThemeMode themeMode;
}
