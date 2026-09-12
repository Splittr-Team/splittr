part of 'settle_expense_bloc.dart';

@freezed
class SettleExpenseEvent extends BaseEvent with _$SettleExpenseEvent {
  const SettleExpenseEvent._();

  const factory SettleExpenseEvent.started(SettleExpenseBlocParams params) =
      _Started;

  const factory SettleExpenseEvent.amountChanged({
    required num amount,
  }) = _AmountChanged;

  const factory SettleExpenseEvent.currencyChanged({
    required String currency,
  }) = _CurrencyChanged;

  const factory SettleExpenseEvent.paidByChanged({
    required String paidBy,
  }) = _PaidByChanged;

  const factory SettleExpenseEvent.receivedByChanged({
    required String receivedBy,
  }) = _ReceivedByChanged;

  const factory SettleExpenseEvent.groupIdChanged({
    String? groupId,
  }) = _GroupIdChanged;

  const factory SettleExpenseEvent.submit() = _Submit;
}
