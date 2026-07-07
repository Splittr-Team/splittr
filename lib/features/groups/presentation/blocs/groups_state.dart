part of 'groups_bloc.dart';

@freezed
sealed class GroupsState extends BaseState with _$GroupsState {
  const GroupsState._();

  const factory GroupsState.initial({
    required GroupsStateStore store,
  }) = Initial;

  const factory GroupsState.loading({
    required GroupsStateStore store,
  }) = Loading;

  const factory GroupsState.loaded({
    required GroupsStateStore store,
    required List<Groups> groups,
  }) = Loaded;

  const factory GroupsState.error({
    required GroupsStateStore store,
    required String message,
  }) = Error;

  @override
  BaseState getFailureState({required Failure failure}) =>
      GroupsState.error(
        store: store.copyWith(loading: false),
        message: failure.message,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      GroupsState.loading(store: store.copyWith(loading: loading));
}

@freezed
class GroupsStateStore with _$GroupsStateStore {
  const GroupsStateStore({
    this.loading = false,
  });

  @override
  final bool loading;
}
