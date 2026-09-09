part of 'dashboard_bloc.dart';

@freezed
class DashboardEvent extends BaseEvent with _$DashboardEvent {
  const DashboardEvent._();

  const factory DashboardEvent.started() = _Started;

  const factory DashboardEvent.refresh() = _Refresh;

  const factory DashboardEvent.expensesUpdated({
    required List<Expense> expenses,
  }) = _ExpensesUpdated;

  const factory DashboardEvent.expensesFailed({
    required Failure failure,
  }) = _ExpensesFailed;
}
