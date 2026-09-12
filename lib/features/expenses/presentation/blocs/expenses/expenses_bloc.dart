import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/expenses/domain/entities/balances.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/usecases/get_balances_usecase.dart';
import 'package:splittr/features/expenses/domain/usecases/get_expenses_usecase.dart';
import 'package:splittr/features/expenses/domain/usecases/watch_expenses_usecase.dart';

part 'expenses_bloc.freezed.dart';
part 'expenses_event.dart';
part 'expenses_state.dart';

@injectable
final class ExpensesBloc
    extends BaseBloc<ExpensesEvent, ExpensesState, ExpensesParams> {
  ExpensesBloc(
    this._getExpensesUseCase,
    this._watchExpensesUseCase,
    this._getBalancesUseCase,
  ) : super(
        const ExpensesState.initial(
          store: ExpensesStateStore(),
        ),
      );

  final GetExpensesUseCase _getExpensesUseCase;
  final WatchExpensesUseCase _watchExpensesUseCase;
  final GetBalancesUseCase _getBalancesUseCase;

  StreamSubscription<EitherFailure<List<Expense>>>? _expensesSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted, transformer: restartable());
    on<_ExpensesUpdated>(_onExpensesUpdated);
    on<_BalancesUpdated>(_onBalancesUpdated);
    on<_ExpensesFailed>(_onExpensesFailed);
    on<_FetchNextPage>(_onFetchNextPage, transformer: droppable());
    on<_ChangeFilter>(_onChangeFilter, transformer: restartable());
  }

  Future<void> _listenToRepositoryStream({
    String? groupId,
    String? friendId,
    bool? personal,
  }) async {
    await _expensesSubscription?.cancel();
    _expensesSubscription = _watchExpensesUseCase
        .call(
          groupId: groupId,
          friendId: friendId,
          personal: personal,
        )
        .listen(
          (result) {
            result.fold(
              (failure) => expensesFailed(failure: failure),
              (expenses) => expensesUpdated(expenses: expenses),
            );
          },
        );
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<ExpensesState> emit,
  ) async {
    await _loadExpensesAndBalances(
      emit: emit,
      groupId: event.groupId,
      friendId: event.friendId,
      personal: event.personal,
    );
  }

  FutureOr<void> _onChangeFilter(
    _ChangeFilter event,
    Emitter<ExpensesState> emit,
  ) async {
    await _loadExpensesAndBalances(
      emit: emit,
      groupId: event.groupId,
      friendId: event.friendId,
      personal: event.personal,
    );
  }

  Future<void> _loadExpensesAndBalances({
    required Emitter<ExpensesState> emit,
    String? groupId,
    String? friendId,
    bool? personal,
  }) async {
    await _listenToRepositoryStream(
      groupId: groupId,
      friendId: friendId,
      personal: personal,
    );

    changeLoadingState(emit: emit, loading: true);

    emit(
      ExpensesState.initial(
        store: state.store.copyWith(
          groupId: groupId,
          friendId: friendId,
          personal: personal,
          nextCursor: null,
          hasMore: false,
          loading: true,
        ),
      ),
    );

    final expensesFuture = _getExpensesUseCase.call(
      GetExpensesParams(
        groupId: groupId,
        friendId: friendId,
        personal: personal,
      ),
    );

    final balancesFuture = _getBalancesUseCase.call(
      GetBalancesParams(
        groupId: groupId,
      ),
    );

    final (expensesResult, balancesResult) = await (
      expensesFuture,
      balancesFuture,
    ).wait;

    balancesResult.fold(
      (_) => null,
      (balances) {
        emit(
          ExpensesState.onBalancesUpdated(
            store: state.store.copyWith(
              balances: balances,
            ),
          ),
        );
      },
    );

    expensesResult.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (paginatedList) => emit(
        ExpensesState.onExpensesUpdated(
          store: state.store.copyWith(
            loading: false,
            hasMore: paginatedList.pagination.hasMore,
            nextCursor: paginatedList.pagination.nextCursor,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onFetchNextPage(
    _FetchNextPage event,
    Emitter<ExpensesState> emit,
  ) async {
    if (state.store.loading || !state.store.hasMore) {
      return;
    }

    changeLoadingState(emit: emit, loading: true);

    final result = await _getExpensesUseCase.call(
      GetExpensesParams(
        cursor: state.store.nextCursor,
        groupId: state.store.groupId,
        friendId: state.store.friendId,
        personal: state.store.personal,
      ),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (paginatedList) => emit(
        ExpensesState.onExpensesUpdated(
          store: state.store.copyWith(
            loading: false,
            hasMore: paginatedList.pagination.hasMore,
            nextCursor: paginatedList.pagination.nextCursor,
          ),
        ),
      ),
    );
  }

  void _onExpensesUpdated(
    _ExpensesUpdated event,
    Emitter<ExpensesState> emit,
  ) {
    emit(
      ExpensesState.onExpensesUpdated(
        store: state.store.copyWith(expenses: event.expenses),
      ),
    );
  }

  void _onBalancesUpdated(
    _BalancesUpdated event,
    Emitter<ExpensesState> emit,
  ) {
    emit(
      ExpensesState.onBalancesUpdated(
        store: state.store.copyWith(balances: event.balances),
      ),
    );
  }

  void _onExpensesFailed(
    _ExpensesFailed event,
    Emitter<ExpensesState> emit,
  ) {
    handleFailure(emit: emit, failure: event.failure);
  }

  @override
  void started(ExpensesParams params) {
    add(
      ExpensesEvent.started(
        groupId: params.groupId,
        friendId: params.friendId,
        personal: params.personal,
      ),
    );
  }

  void expensesFailed({required Failure failure}) {
    add(ExpensesEvent.expensesFailed(failure: failure));
  }

  void expensesUpdated({required List<Expense> expenses}) {
    add(ExpensesEvent.expensesUpdated(expenses: expenses));
  }

  void balancesUpdated({required Balances balances}) {
    add(ExpensesEvent.balancesUpdated(balances: balances));
  }

  void fetchNextPage() {
    add(const ExpensesEvent.fetchNextPage());
  }

  void changeFilter({
    String? groupId,
    String? friendId,
    bool? personal,
  }) {
    add(
      ExpensesEvent.changeFilter(
        groupId: groupId,
        friendId: friendId,
        personal: personal,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _expensesSubscription?.cancel();
    return super.close();
  }
}
