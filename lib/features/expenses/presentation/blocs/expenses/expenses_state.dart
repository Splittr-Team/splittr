part of 'expenses_bloc.dart';

@freezed
sealed class ExpensesState extends BaseState with _$ExpensesState {
  const ExpensesState._();

  const factory ExpensesState.initial({
    required ExpensesStateStore store,
  }) = Initial;

  const factory ExpensesState.onExpensesUpdated({
    required ExpensesStateStore store,
  }) = OnExpensesUpdated;

  const factory ExpensesState.onBalancesUpdated({
    required ExpensesStateStore store,
  }) = OnBalancesUpdated;

  const factory ExpensesState.onFailure({
    required ExpensesStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory ExpensesState.changeLoaderState({
    required ExpensesStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      ExpensesState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      ExpensesState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class ExpensesStateStore with _$ExpensesStateStore {
  const ExpensesStateStore({
    this.expenses = const [],
    this.balances,
    this.loading = false,
    this.hasMore = false,
    this.nextCursor,
    this.groupId,
    this.friendId,
    this.personal,
  });

  @override
  final List<Expense> expenses;
  @override
  final Balances? balances;
  @override
  final bool loading;
  @override
  final bool hasMore;
  @override
  final String? nextCursor;
  @override
  final String? groupId;
  @override
  final String? friendId;
  @override
  final bool? personal;
}

class ExpensesParams extends Equatable {
  const ExpensesParams({
    this.groupId,
    this.friendId,
    this.personal,
  });

  final String? groupId;
  final String? friendId;
  final bool? personal;

  @override
  List<Object?> get props => [groupId, friendId, personal];
}
