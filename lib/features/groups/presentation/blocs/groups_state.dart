part of 'groups_bloc.dart';

@freezed
sealed class GroupsState extends BaseState with _$GroupsState {
  const GroupsState._();

  const factory GroupsState.initial({
    required GroupsStateStore store,
  }) = Initial;

  const factory GroupsState.loaded({
    required GroupsStateStore store,
    required List<Group> groups,
  }) = Loaded;

  const factory GroupsState.onFailure({
    required GroupsStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory GroupsState.changeLoaderState({
    required GroupsStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      GroupsState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      GroupsState.changeLoaderState(store: store.copyWith(loading: loading));
}

@freezed
class GroupsStateStore with _$GroupsStateStore {
  const GroupsStateStore({
    this.loading = false,
  });

  @override
  final bool loading;
}
