import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/constants/constants.dart';
import 'package:splittr/features/quick_settle/dataclass/split_transaction.dart';

part 'quick_settle_bloc.freezed.dart';
part 'quick_settle_event.dart';
part 'quick_settle_state.dart';

@injectable
final class QuickSettleBloc
    extends BaseBloc<QuickSettleEvent, QuickSettleState> {
  QuickSettleBloc()
    : super(const QuickSettleState.initial(store: QuickSettleStateStore()));

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_CalculateTransactions>(_onCalculateTransactions);
    on<_ToggleListView>(_onToggleListView);
  }

  void _onStarted(_Started event, Emitter<QuickSettleState> emit) {
    final people = List<({double amount, String name})>.from(event.peopleRecord)
      ..sort((a, b) => a.amount.compareTo(b.amount));

    double total = 0;
    for (final person in people) {
      total += person.amount;
    }
    final individualShare = total / people.length;

    final individualShareList = List<double>.generate(
      people.length,
      (index) => people[index].amount - individualShare,
    );

    emit(
      QuickSettleState.initial(
        store: state.store.copyWith(
          peopleRecord: people,
          total: total,
          individualShare: individualShare,
          individualShareList: individualShareList,
        ),
      ),
    );

    add(const QuickSettleEvent.calculateTransactions());
  }

  void _onCalculateTransactions(
    _CalculateTransactions event,
    Emitter<QuickSettleState> emit,
  ) {
    final people = state.store.peopleRecord;
    final individualShareList = List<double>.from(
      state.store.individualShareList,
    );
    final finalTransaction = <Map<String, String>>[];
    final tags = <SplitTransaction>[];
    final summaryMap = <String, List<Map<String, double>>>{};

    var i = 0;
    var j = people.length - 1;

    while (i < j) {
      final sum = individualShareList[i] + individualShareList[j];
      if (sum > 0) {
        finalTransaction.add({
          people[i].name: '${people[j].name}|${individualShareList[i]}',
        });

        tags.add(
          SplitTransaction(
            people[i].name,
            people[j].name,
            individualShareList[i],
          ),
        );
        individualShareList[i] = 0;
        individualShareList[j] = sum;
        i++;
      } else if (sum < 0) {
        finalTransaction.add({
          people[i].name: '${people[j].name}|-${individualShareList[j]}',
        });

        tags.add(
          SplitTransaction(
            people[i].name,
            people[j].name,
            -individualShareList[j],
          ),
        );
        individualShareList[j] = 0;
        individualShareList[i] = sum;
        j--;
      } else {
        finalTransaction.add({
          people[i].name: '${people[j].name}|${individualShareList[i]}',
        });

        tags.add(
          SplitTransaction(
            people[i].name,
            people[j].name,
            individualShareList[i],
          ),
        );
        individualShareList[j] = 0;
        individualShareList[i] = 0;
        i++;
        j--;
      }
    }

    for (final item in finalTransaction) {
      final giver = item.keys.first;
      final value = item.values.first;

      final splitValue = value.split('|');
      final receiver = splitValue[0];
      final amount = double.parse(splitValue[1]);

      if (!summaryMap.containsKey(receiver)) {
        summaryMap[receiver] = [];
      }

      summaryMap[receiver]!.add({giver: amount});
    }

    emit(
      QuickSettleState.initial(
        store: state.store.copyWith(
          finalTransaction: finalTransaction,
          summaryMap: summaryMap,
          tags: tags,
        ),
      ),
    );
  }

  void _onToggleListView(
    _ToggleListView event,
    Emitter<QuickSettleState> emit,
  ) {
    emit(
      QuickSettleState.initial(
        store: state.store.copyWith(toggleCard: !state.store.toggleCard),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    final peopleRecords =
        args?[StringConstants.peopleRecords]
            as List<({double amount, String name})>;
    add(QuickSettleEvent.started(peopleRecord: peopleRecords));
  }

  void toggleListView() {
    add(const QuickSettleEvent.toggleListView());
  }
}
