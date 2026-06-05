import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';

part 'quick_split_bloc.freezed.dart';
part 'quick_split_event.dart';
part 'quick_split_state.dart';

@injectable
final class QuickSplitBloc extends BaseBloc<QuickSplitEvent, QuickSplitState> {
  QuickSplitBloc()
    : super(const QuickSplitState.initial(store: QuickSplitStateStore()));

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_AddPerson>(_onAddPerson);
    on<_DeletePerson>(_onDeletePerson);
    on<_NameChanged>(_onNameChanged);
    on<_AmountChanged>(_onAmountChanged);
    on<_QuickSettleClicked>(_onQuickSettleClicked);
    on<_ClearData>(_onClearData);
  }

  void _onStarted(_Started event, Emitter<QuickSplitState> emit) {}

  void _onAddPerson(_AddPerson event, Emitter<QuickSplitState> emit) {
    final updatedPeople = List<({String amount, String name})>.from(
      state.store.peopleRecords,
    )..add((name: '', amount: '0'));
    emit(
      QuickSplitState.addedPerson(
        store: state.store.copyWith(peopleRecords: updatedPeople),
      ),
    );
  }

  void _onDeletePerson(_DeletePerson event, Emitter<QuickSplitState> emit) {
    final updatedPeopleRecord = List<({String amount, String name})>.from(
      state.store.peopleRecords,
    )..removeAt(event.index);

    emit(
      QuickSplitState.deletedPerson(
        store: state.store.copyWith(peopleRecords: updatedPeopleRecord),
      ),
    );
  }

  void _onNameChanged(_NameChanged event, Emitter<QuickSplitState> emit) {
    final existingRecord = state.store.peopleRecords[event.index];
    final records =
        List<({String amount, String name})>.from(state.store.peopleRecords)
          ..replaceRange(event.index, event.index + 1, [
            (name: event.name, amount: existingRecord.amount),
          ]);

    emit(
      QuickSplitState.nameChange(
        store: state.store.copyWith(peopleRecords: records),
      ),
    );
  }

  void _onAmountChanged(_AmountChanged event, Emitter<QuickSplitState> emit) {
    final existingRecord = state.store.peopleRecords[event.index];
    final records =
        List<({String amount, String name})>.from(state.store.peopleRecords)
          ..replaceRange(event.index, event.index + 1, [
            (name: existingRecord.name, amount: event.amount),
          ]);

    emit(
      QuickSplitState.amountChange(
        store: state.store.copyWith(peopleRecords: records),
      ),
    );
  }

  void _onQuickSettleClicked(
    _QuickSettleClicked event,
    Emitter<QuickSplitState> emit,
  ) {
    changeLoadingState(emit: emit, loading: true);
    for (final peopleRecord in state.store.peopleRecords) {
      final amount = double.tryParse(peopleRecord.amount);
      if (amount == null || amount < 0) {
        emit(
          QuickSplitState.invalidAmount(
            store: state.store.copyWith(loading: false),
            invalidAmount: peopleRecord.amount,
          ),
        );
        return;
      }
      if (peopleRecord.name.isEmpty) {
        emit(
          QuickSplitState.emptyName(
            store: state.store.copyWith(loading: false),
          ),
        );
        return;
      }
    }

    emit(
      QuickSplitState.quickSettle(
        store: state.store.copyWith(
          loading: false,
          peopleRecords: state.store.peopleRecords,
        ),
      ),
    );
  }

  void _onClearData(_ClearData event, Emitter<QuickSplitState> emit) {
    emit(
      QuickSplitState.initial(store: state.store.copyWith(peopleRecords: [])),
    );
  }

  void clearData() {
    add(const QuickSplitEvent.clearData());
  }

  void addPerson() {
    add(const QuickSplitEvent.addPerson());
  }

  void amountChanged({required int index, required String amount}) {
    add(QuickSplitEvent.amountChanged(index: index, amount: amount));
  }

  void nameChanged({required int index, required String name}) {
    add(QuickSplitEvent.nameChanged(index: index, name: name));
  }

  void deletePerson({required int index}) {
    add(QuickSplitEvent.deletePerson(index: index));
  }

  void quickSettleClicked() {
    add(const QuickSplitEvent.quickSettleClicked());
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const QuickSplitEvent.started());
  }
}
