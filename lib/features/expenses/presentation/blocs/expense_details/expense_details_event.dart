part of 'expense_details_bloc.dart';

@freezed
class ExpenseDetailsEvent extends BaseEvent with _$ExpenseDetailsEvent {
  const ExpenseDetailsEvent._();

  const factory ExpenseDetailsEvent.started({
    required String expenseId,
    Expense? expense,
  }) = _Started;

  const factory ExpenseDetailsEvent.deleteExpense() = _DeleteExpense;
}
