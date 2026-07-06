part of 'dashboard_bloc.dart';

@freezed
sealed class DashboardState extends BaseState with _$DashboardState {
  const DashboardState._();

  const factory DashboardState.initial({required DashboardStateStore store}) =
      Initial;

  const factory DashboardState.changeLoaderState({
    required DashboardStateStore store,
  }) = ChangeLoaderState;

  const factory DashboardState.onFailure({
    required DashboardStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory DashboardState.onIndexChanged({
    required DashboardStateStore store,
  }) = OnIndexChanged;

  @override
  BaseState getFailureState({required Failure failure}) =>
      DashboardState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      DashboardState.changeLoaderState(store: store.copyWith(loading: loading));
}

@freezed
class DashboardStateStore with _$DashboardStateStore {
  const DashboardStateStore({
    this.loading = false,
    this.selectedIndex = 0,
  });

  @override
  final bool loading;
  @override
  final int selectedIndex;
}
