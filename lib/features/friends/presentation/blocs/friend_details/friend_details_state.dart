part of 'friend_details_bloc.dart';

@freezed
sealed class FriendDetailsState extends BaseState with _$FriendDetailsState {
  const FriendDetailsState._();

  const factory FriendDetailsState.initial({
    required FriendDetailsStateStore store,
  }) = Initial;

  const factory FriendDetailsState.onExpensesUpdated({
    required FriendDetailsStateStore store,
  }) = OnExpensesUpdated;

  const factory FriendDetailsState.onBalancesUpdated({
    required FriendDetailsStateStore store,
  }) = OnBalancesUpdated;

  const factory FriendDetailsState.onFailure({
    required FriendDetailsStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory FriendDetailsState.changeLoaderState({
    required FriendDetailsStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      FriendDetailsState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      FriendDetailsState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class FriendDetailsStateStore with _$FriendDetailsStateStore {
  const FriendDetailsStateStore({
    this.loading = false,
    this.friendId = '',
    this.friend,
    this.balances,
    this.expenses = const [],
    this.hasMore = false,
    this.nextCursor,
  });

  @override
  final bool loading;
  @override
  final String friendId;
  @override
  final Friend? friend;
  @override
  final Balances? balances;
  @override
  final List<Expense> expenses;
  @override
  final bool hasMore;
  @override
  final String? nextCursor;
}

class FriendDetailsParams extends Equatable {
  const FriendDetailsParams({
    required this.friendId,
    this.friend,
  });

  final String friendId;
  final Friend? friend;

  @override
  List<Object?> get props => [friendId, friend];
}
