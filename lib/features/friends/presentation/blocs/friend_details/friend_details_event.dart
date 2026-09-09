part of 'friend_details_bloc.dart';

@freezed
class FriendDetailsEvent extends BaseEvent with _$FriendDetailsEvent {
  const FriendDetailsEvent._();

  const factory FriendDetailsEvent.started({
    required String friendId,
    Friend? friend,
  }) = _Started;

  const factory FriendDetailsEvent.expensesUpdated({
    required List<Expense> expenses,
  }) = _ExpensesUpdated;

  const factory FriendDetailsEvent.balancesUpdated({
    required Balances balances,
  }) = _BalancesUpdated;

  const factory FriendDetailsEvent.expensesFailed({
    required Failure failure,
  }) = _ExpensesFailed;

  const factory FriendDetailsEvent.fetchNextPage() = _FetchNextPage;
}
