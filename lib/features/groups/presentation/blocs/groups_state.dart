part of 'groups_bloc.dart';

@freezed
sealed class GroupsState extends BaseState with _$GroupsState {
  const GroupsState._();

  const factory GroupsState.initial({
    required GroupsStateStore store,
  }) = Initial;

  const factory GroupsState.onGroupsUpdate({
    required GroupsStateStore store,
  }) = OnGroupsUpdate;

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
    required this.groups,
    this.loading = false,
    this.hasMore = false,
    this.nextCursor,
  });

  @override
  final bool loading;
  @override
  final List<Group> groups;
  @override
  final bool hasMore;
  @override
  final String? nextCursor;
}
