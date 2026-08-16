part of 'group_bloc.dart';

@freezed
sealed class GroupState extends BaseState with _$GroupState {
  const GroupState._();

  const factory GroupState.initial({
    required GroupStateStore store,
  }) = Initial;

  const factory GroupState.onGroupDeleted({
    required GroupStateStore store,
  }) = OnGroupDeleted;

  const factory GroupState.onGroupLeft({
    required GroupStateStore store,
  }) = OnGroupLeft;

  const factory GroupState.onMembersAdded({
    required GroupStateStore store,
  }) = OnMembersAdded;

  const factory GroupState.onFailure({
    required GroupStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory GroupState.changeLoaderState({
    required GroupStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      GroupState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      GroupState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class GroupStateStore with _$GroupStateStore {
  const GroupStateStore({
    this.loading = false,
    this.group,
  });

  @override
  final bool loading;
  @override
  final Group? group;
}
