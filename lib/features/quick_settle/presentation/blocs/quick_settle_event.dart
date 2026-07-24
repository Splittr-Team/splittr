part of 'quick_settle_bloc.dart';

@freezed
class QuickSettleEvent extends BaseEvent with _$QuickSettleEvent {
  const QuickSettleEvent._();

  const factory QuickSettleEvent.started({
    required List<({num amount, String name})> peopleRecord,
    required String splitTitle,
  }) = _Started;

  const factory QuickSettleEvent.calculateTransactions() =
      _CalculateTransactions;

  const factory QuickSettleEvent.toggleListView() = _ToggleListView;

  const factory QuickSettleEvent.saveSplit() = _SaveSplit;
}
