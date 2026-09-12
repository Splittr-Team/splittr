import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';
import 'package:splittr/features/activities/domain/usecases/get_activities_usecase.dart';
import 'package:splittr/features/expenses/domain/entities/balances.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/usecases/get_balances_usecase.dart';
import 'package:splittr/features/expenses/domain/usecases/watch_expenses_usecase.dart';

part 'dashboard_bloc.freezed.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
final class DashboardBloc
    extends BaseBloc<DashboardEvent, DashboardState, NoParams> {
  DashboardBloc(
    this._getBalancesUseCase,
    this._watchExpensesUseCase,
    this._getActivitiesUseCase,
  ) : super(
        const DashboardState.initial(
          store: DashboardStateStore(),
        ),
      );

  final GetBalancesUseCase _getBalancesUseCase;
  final WatchExpensesUseCase _watchExpensesUseCase;
  final GetActivitiesUseCase _getActivitiesUseCase;

  StreamSubscription<EitherFailure<List<Expense>>>? _expensesSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted, transformer: restartable());
    on<_Refresh>(_onRefresh, transformer: restartable());
    on<_ExpensesUpdated>(_onExpensesUpdated);
    on<_ExpensesFailed>(_onExpensesFailed);
  }

  Future<void> _listenToExpensesStream() async {
    await _expensesSubscription?.cancel();
    _expensesSubscription = _watchExpensesUseCase.call().listen((result) {
      result.fold(
        (failure) => expensesFailed(failure: failure),
        (expenses) => expensesUpdated(expenses: expenses),
      );
    });
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadDashboard(emit: emit);
  }

  FutureOr<void> _onRefresh(
    _Refresh event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadDashboard(emit: emit);
  }

  Future<void> _loadDashboard({
    required Emitter<DashboardState> emit,
  }) async {
    await _listenToExpensesStream();

    changeLoadingState(emit: emit, loading: true);

    final balancesFuture = _getBalancesUseCase.call(
      const GetBalancesParams(),
    );
    final activitiesFuture = _getActivitiesUseCase.call(
      const GetActivitiesParams(limit: 5),
    );

    final (balancesResult, activitiesResult) = await (
      balancesFuture,
      activitiesFuture,
    ).wait;

    var currentStore = state.store.copyWith(loading: false);

    balancesResult.fold(
      (_) {},
      (balances) {
        currentStore = currentStore.copyWith(balances: balances);
      },
    );

    activitiesResult.fold(
      (_) {},
      (paginatedActivities) {
        currentStore = currentStore.copyWith(
          recentActivities: paginatedActivities.items,
        );
      },
    );

    emit(DashboardState.onDashboardLoaded(store: currentStore));
  }

  void _onExpensesUpdated(
    _ExpensesUpdated event,
    Emitter<DashboardState> emit,
  ) {
    emit(
      DashboardState.onExpensesUpdated(
        store: state.store.copyWith(recentExpenses: event.expenses),
      ),
    );
  }

  void _onExpensesFailed(
    _ExpensesFailed event,
    Emitter<DashboardState> emit,
  ) {
    handleFailure(emit: emit, failure: event.failure);
  }

  @override
  void started(NoParams params) {
    add(const DashboardEvent.started());
  }

  void refresh() {
    add(const DashboardEvent.refresh());
  }

  void expensesUpdated({required List<Expense> expenses}) {
    add(DashboardEvent.expensesUpdated(expenses: expenses));
  }

  void expensesFailed({required Failure failure}) {
    add(DashboardEvent.expensesFailed(failure: failure));
  }

  @override
  Future<void> close() async {
    await _expensesSubscription?.cancel();
    return super.close();
  }
}
