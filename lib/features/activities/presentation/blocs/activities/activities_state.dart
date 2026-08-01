part of 'activities_bloc.dart';

@freezed
sealed class ActivitiesState extends BaseState with _$ActivitiesState {
  const ActivitiesState._();

  const factory ActivitiesState.initial({
    required ActivitiesStateStore store,
  }) = Initial;

  const factory ActivitiesState.onActivitiesUpdate({
    required ActivitiesStateStore store,
  }) = OnActivitiesUpdate;

  const factory ActivitiesState.onFailure({
    required ActivitiesStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory ActivitiesState.changeLoaderState({
    required ActivitiesStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      ActivitiesState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      ActivitiesState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class ActivitiesStateStore with _$ActivitiesStateStore {
  const ActivitiesStateStore({
    required this.activities,
    this.loading = false,
    this.hasMore = false,
    this.nextCursor,
  });

  @override
  final bool loading;
  @override
  final List<Activity> activities;
  @override
  final bool hasMore;
  @override
  final String? nextCursor;
}
