import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/usecases/settle_expense_usecase.dart';

part 'settle_expense_bloc.freezed.dart';
part 'settle_expense_event.dart';
part 'settle_expense_state.dart';

@injectable
final class SettleExpenseBloc
    extends
        BaseBloc<
          SettleExpenseEvent,
          SettleExpenseState,
          SettleExpenseBlocParams
        > {
  SettleExpenseBloc(this._settleExpenseUseCase)
    : super(
        const SettleExpenseState.initial(
          store: SettleExpenseStateStore(),
        ),
      );

  final SettleExpenseUseCase _settleExpenseUseCase;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_AmountChanged>(_onAmountChanged);
    on<_CurrencyChanged>(_onCurrencyChanged);
    on<_PaidByChanged>(_onPaidByChanged);
    on<_ReceivedByChanged>(_onReceivedByChanged);
    on<_GroupIdChanged>(_onGroupIdChanged);
    on<_Submit>(_onSubmit);
  }

  @override
  void started(SettleExpenseBlocParams params) {
    add(SettleExpenseEvent.started(params));
  }

  void _onStarted(
    _Started event,
    Emitter<SettleExpenseState> emit,
  ) {
    emit(
      SettleExpenseState.onDraftUpdated(
        store: state.store.copyWith(
          amount: event.params.amount ?? 0,
          currency: event.params.currency ?? 'INR',
          paidBy: event.params.paidBy ?? '',
          receivedBy: event.params.receivedBy ?? '',
          groupId: event.params.groupId,
        ),
      ),
    );
  }

  void _onAmountChanged(
    _AmountChanged event,
    Emitter<SettleExpenseState> emit,
  ) {
    emit(
      SettleExpenseState.onDraftUpdated(
        store: state.store.copyWith(amount: event.amount),
      ),
    );
  }

  void _onCurrencyChanged(
    _CurrencyChanged event,
    Emitter<SettleExpenseState> emit,
  ) {
    emit(
      SettleExpenseState.onDraftUpdated(
        store: state.store.copyWith(currency: event.currency),
      ),
    );
  }

  void _onPaidByChanged(
    _PaidByChanged event,
    Emitter<SettleExpenseState> emit,
  ) {
    emit(
      SettleExpenseState.onDraftUpdated(
        store: state.store.copyWith(paidBy: event.paidBy),
      ),
    );
  }

  void _onReceivedByChanged(
    _ReceivedByChanged event,
    Emitter<SettleExpenseState> emit,
  ) {
    emit(
      SettleExpenseState.onDraftUpdated(
        store: state.store.copyWith(receivedBy: event.receivedBy),
      ),
    );
  }

  void _onGroupIdChanged(
    _GroupIdChanged event,
    Emitter<SettleExpenseState> emit,
  ) {
    emit(
      SettleExpenseState.onDraftUpdated(
        store: state.store.copyWith(groupId: event.groupId),
      ),
    );
  }

  FutureOr<void> _onSubmit(
    _Submit event,
    Emitter<SettleExpenseState> emit,
  ) async {
    final store = state.store;
    if (!store.isValid) return;

    changeLoadingState(emit: emit, loading: true);

    final result = await _settleExpenseUseCase.call(
      SettleExpenseParams(
        amount: store.amount,
        currency: store.currency,
        paidBy: store.paidBy,
        receivedBy: store.receivedBy,
        groupId: store.groupId,
      ),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (expense) => emit(
        SettleExpenseState.onSettleSuccess(
          store: state.store.copyWith(loading: false),
          expense: expense,
        ),
      ),
    );
  }

  void amountChanged({required num amount}) {
    add(SettleExpenseEvent.amountChanged(amount: amount));
  }

  void currencyChanged({required String currency}) {
    add(SettleExpenseEvent.currencyChanged(currency: currency));
  }

  void paidByChanged({required String paidBy}) {
    add(SettleExpenseEvent.paidByChanged(paidBy: paidBy));
  }

  void receivedByChanged({required String receivedBy}) {
    add(SettleExpenseEvent.receivedByChanged(receivedBy: receivedBy));
  }

  void groupIdChanged({String? groupId}) {
    add(SettleExpenseEvent.groupIdChanged(groupId: groupId));
  }

  void submit() {
    add(const SettleExpenseEvent.submit());
  }
}
