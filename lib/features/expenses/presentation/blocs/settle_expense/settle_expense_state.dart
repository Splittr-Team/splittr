part of 'settle_expense_bloc.dart';

@freezed
sealed class SettleExpenseState extends BaseState with _$SettleExpenseState {
  const SettleExpenseState._();

  const factory SettleExpenseState.initial({
    required SettleExpenseStateStore store,
  }) = Initial;

  const factory SettleExpenseState.onDraftUpdated({
    required SettleExpenseStateStore store,
  }) = OnDraftUpdated;

  const factory SettleExpenseState.onSettleSuccess({
    required SettleExpenseStateStore store,
    required Expense expense,
  }) = OnSettleSuccess;

  const factory SettleExpenseState.onFailure({
    required SettleExpenseStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory SettleExpenseState.changeLoaderState({
    required SettleExpenseStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      SettleExpenseState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      SettleExpenseState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class SettleExpenseStateStore with _$SettleExpenseStateStore {
  const SettleExpenseStateStore({
    this.loading = false,
    this.amount = 0,
    this.currency = 'INR',
    this.paidBy = '',
    this.receivedBy = '',
    this.groupId,
  });

  @override
  final bool loading;
  @override
  final num amount;
  @override
  final String currency;
  @override
  final String paidBy;
  @override
  final String receivedBy;
  @override
  final String? groupId;

  bool get isValid =>
      amount > 0 &&
      currency.isNotEmpty &&
      paidBy.isNotEmpty &&
      receivedBy.isNotEmpty &&
      paidBy != receivedBy;
}

class SettleExpenseBlocParams extends Equatable {
  const SettleExpenseBlocParams({
    this.amount,
    this.currency,
    this.paidBy,
    this.receivedBy,
    this.groupId,
  });

  final num? amount;
  final String? currency;
  final String? paidBy;
  final String? receivedBy;
  final String? groupId;

  @override
  List<Object?> get props => [
    amount,
    currency,
    paidBy,
    receivedBy,
    groupId,
  ];
}
