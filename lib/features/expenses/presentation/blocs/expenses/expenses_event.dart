part of 'expenses_bloc.dart';

@freezed
class ExpensesEvent extends BaseEvent with _$ExpensesEvent {
  const ExpensesEvent._();

  const factory ExpensesEvent.started({
    String? groupId,
    String? friendId,
    bool? personal,
  }) = _Started;

  const factory ExpensesEvent.expensesUpdated({
    required List<Expense> expenses,
  }) = _ExpensesUpdated;

  const factory ExpensesEvent.balancesUpdated({
    required Balances balances,
  }) = _BalancesUpdated;

  const factory ExpensesEvent.expensesFailed({
    required Failure failure,
  }) = _ExpensesFailed;

  const factory ExpensesEvent.fetchNextPage() = _FetchNextPage;

  const factory ExpensesEvent.changeFilter({
    String? groupId,
    String? friendId,
    bool? personal,
  }) = _ChangeFilter;
}
