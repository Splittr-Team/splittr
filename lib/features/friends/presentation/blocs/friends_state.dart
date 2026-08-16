part of 'friends_bloc.dart';

@freezed
sealed class FriendsState extends BaseState with _$FriendsState {
  const FriendsState._();

  const factory FriendsState.initial({required FriendsStateStore store}) =
      Initial;

  const factory FriendsState.changeLoaderState({
    required FriendsStateStore store,
  }) = ChangeLoaderState;

  const factory FriendsState.onFriendsUpdated({
    required FriendsStateStore store,
  }) = OnFriendsUpdated;

  const factory FriendsState.onFailure({
    required FriendsStateStore store,
    required Failure failure,
  }) = OnFailure;

  @override
  BaseState getFailureState({required Failure failure}) =>
      FriendsState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      FriendsState.changeLoaderState(store: store.copyWith(loading: loading));
}

@freezed
class FriendsStateStore with _$FriendsStateStore {
  const FriendsStateStore({
    required this.friends,
    this.loading = false,
    this.hasMore = false,
    this.nextCursor,
  });

  @override
  final bool loading;
  @override
  final List<Friend> friends;
  @override
  final bool hasMore;
  @override
  final String? nextCursor;
}
