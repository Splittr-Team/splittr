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
import 'package:splittr/features/friends/domain/entities/friend.dart';

part 'friend_details_bloc.freezed.dart';
part 'friend_details_event.dart';
part 'friend_details_state.dart';

@injectable
final class FriendDetailsBloc
    extends
        BaseBloc<FriendDetailsEvent, FriendDetailsState, FriendDetailsParams> {
  FriendDetailsBloc(
    this._getExpensesUseCase,
    this._watchExpensesUseCase,
    this._getBalancesUseCase,
  ) : super(
        const FriendDetailsState.initial(
          store: FriendDetailsStateStore(),
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
  }

  Future<void> _listenToRepositoryStream({required String friendId}) async {
    await _expensesSubscription?.cancel();
    _expensesSubscription = _watchExpensesUseCase
        .call(friendId: friendId)
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
    Emitter<FriendDetailsState> emit,
  ) async {
    await _listenToRepositoryStream(friendId: event.friendId);

    changeLoadingState(emit: emit, loading: true);

    emit(
      FriendDetailsState.initial(
        store: state.store.copyWith(
          friendId: event.friendId,
          friend: event.friend ?? state.store.friend,
          nextCursor: null,
          hasMore: false,
          loading: true,
        ),
      ),
    );

    final expensesFuture = _getExpensesUseCase.call(
      GetExpensesParams(
        friendId: event.friendId,
      ),
    );

    final balancesFuture = _getBalancesUseCase.call(
      const GetBalancesParams(),
    );

    final (expensesResult, balancesResult) = await (
      expensesFuture,
      balancesFuture,
    ).wait;

    balancesResult.fold(
      (_) => null,
      (balances) {
        emit(
          FriendDetailsState.onBalancesUpdated(
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
        FriendDetailsState.onExpensesUpdated(
          store: state.store.copyWith(
            loading: false,
            expenses: paginatedList.items,
            hasMore: paginatedList.pagination.hasMore,
            nextCursor: paginatedList.pagination.nextCursor,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onFetchNextPage(
    _FetchNextPage event,
    Emitter<FriendDetailsState> emit,
  ) async {
    if (state.store.loading || !state.store.hasMore) {
      return;
    }

    changeLoadingState(emit: emit, loading: true);

    final result = await _getExpensesUseCase.call(
      GetExpensesParams(
        cursor: state.store.nextCursor,
        friendId: state.store.friendId,
      ),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (paginatedList) => emit(
        FriendDetailsState.onExpensesUpdated(
          store: state.store.copyWith(
            loading: false,
            expenses: [...state.store.expenses, ...paginatedList.items],
            hasMore: paginatedList.pagination.hasMore,
            nextCursor: paginatedList.pagination.nextCursor,
          ),
        ),
      ),
    );
  }

  void _onExpensesUpdated(
    _ExpensesUpdated event,
    Emitter<FriendDetailsState> emit,
  ) {
    emit(
      FriendDetailsState.onExpensesUpdated(
        store: state.store.copyWith(expenses: event.expenses),
      ),
    );
  }

  void _onBalancesUpdated(
    _BalancesUpdated event,
    Emitter<FriendDetailsState> emit,
  ) {
    emit(
      FriendDetailsState.onBalancesUpdated(
        store: state.store.copyWith(balances: event.balances),
      ),
    );
  }

  void _onExpensesFailed(
    _ExpensesFailed event,
    Emitter<FriendDetailsState> emit,
  ) {
    handleFailure(emit: emit, failure: event.failure);
  }

  @override
  void started(FriendDetailsParams params) {
    add(
      FriendDetailsEvent.started(
        friendId: params.friendId,
        friend: params.friend,
      ),
    );
  }

  void expensesFailed({required Failure failure}) {
    add(FriendDetailsEvent.expensesFailed(failure: failure));
  }

  void expensesUpdated({required List<Expense> expenses}) {
    add(FriendDetailsEvent.expensesUpdated(expenses: expenses));
  }

  void balancesUpdated({required Balances balances}) {
    add(FriendDetailsEvent.balancesUpdated(balances: balances));
  }

  void fetchNextPage() {
    add(const FriendDetailsEvent.fetchNextPage());
  }

  @override
  Future<void> close() async {
    await _expensesSubscription?.cancel();
    return super.close();
  }
}
