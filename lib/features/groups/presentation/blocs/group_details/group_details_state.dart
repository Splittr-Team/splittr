part of 'group_details_bloc.dart';

@freezed
sealed class GroupDetailsState extends BaseState with _$GroupDetailsState {
  const GroupDetailsState._();

  const factory GroupDetailsState.initial({
    required GroupDetailsStateStore store,
  }) = Initial;

  const factory GroupDetailsState.onFailure({
    required GroupDetailsStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory GroupDetailsState.changeLoaderState({
    required GroupDetailsStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      GroupDetailsState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      GroupDetailsState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class GroupDetailsStateStore with _$GroupDetailsStateStore {
  const GroupDetailsStateStore({
    this.loading = false,
  });

  @override
  final bool loading;
}
