part of 'create_expense_bloc.dart';

@freezed
class CreateExpenseEvent extends BaseEvent with _$CreateExpenseEvent {
  const CreateExpenseEvent._();

  const factory CreateExpenseEvent.started(CreateExpenseBlocParams params) =
      _Started;

  const factory CreateExpenseEvent.descriptionChanged({
    required String description,
  }) = _DescriptionChanged;

  const factory CreateExpenseEvent.amountChanged({
    required num amount,
  }) = _AmountChanged;

  const factory CreateExpenseEvent.currencyChanged({
    required String currency,
  }) = _CurrencyChanged;

  const factory CreateExpenseEvent.paidByChanged({
    required String paidBy,
  }) = _PaidByChanged;

  const factory CreateExpenseEvent.splitTypeChanged({
    required SplitType splitType,
  }) = _SplitTypeChanged;

  const factory CreateExpenseEvent.splitsChanged({
    required List<InputSplit> splits,
  }) = _SplitsChanged;

  const factory CreateExpenseEvent.participantToggled({
    required String userId,
  }) = _ParticipantToggled;

  const factory CreateExpenseEvent.splitAmountChanged({
    required String userId,
    required num amount,
  }) = _SplitAmountChanged;

  const factory CreateExpenseEvent.splitPercentageChanged({
    required String userId,
    required num percentage,
  }) = _SplitPercentageChanged;

  const factory CreateExpenseEvent.categoryChanged({
    String? category,
  }) = _CategoryChanged;

  const factory CreateExpenseEvent.groupIdChanged({
    String? groupId,
  }) = _GroupIdChanged;

  const factory CreateExpenseEvent.groupSelected({
    String? groupId,
  }) = _GroupSelected;

  const factory CreateExpenseEvent.participantAdded({
    required String userId,
    String? name,
  }) = _ParticipantAdded;

  const factory CreateExpenseEvent.submit() = _Submit;
}
