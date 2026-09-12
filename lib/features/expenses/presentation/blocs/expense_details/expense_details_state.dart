part of 'expense_details_bloc.dart';

@freezed
sealed class ExpenseDetailsState extends BaseState with _$ExpenseDetailsState {
  const ExpenseDetailsState._();

  const factory ExpenseDetailsState.initial({
    required ExpenseDetailsStateStore store,
  }) = Initial;

  const factory ExpenseDetailsState.onExpenseLoaded({
    required ExpenseDetailsStateStore store,
    required Expense expense,
  }) = OnExpenseLoaded;

  const factory ExpenseDetailsState.onExpenseDeleted({
    required ExpenseDetailsStateStore store,
  }) = OnExpenseDeleted;

  const factory ExpenseDetailsState.onFailure({
    required ExpenseDetailsStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory ExpenseDetailsState.changeLoaderState({
    required ExpenseDetailsStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      ExpenseDetailsState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      ExpenseDetailsState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class ExpenseDetailsStateStore with _$ExpenseDetailsStateStore {
  const ExpenseDetailsStateStore({
    this.loading = false,
    this.isDeleting = false,
    this.expenseId = '',
    this.expense,
    this.userNames = const {},
  });

  @override
  final bool loading;
  @override
  final bool isDeleting;
  @override
  final String expenseId;
  @override
  final Expense? expense;
  @override
  final Map<String, String> userNames;
}

class ExpenseDetailsParams extends Equatable {
  const ExpenseDetailsParams({
    required this.expenseId,
    this.expense,
  });

  final String expenseId;
  final Expense? expense;

  @override
  List<Object?> get props => [expenseId, expense];
}
