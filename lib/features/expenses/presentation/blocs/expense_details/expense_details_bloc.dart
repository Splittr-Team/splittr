import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/usecases/delete_expense_usecase.dart';
import 'package:splittr/features/expenses/domain/usecases/get_expense_details_usecase.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/domain/usecases/get_friends_usecase.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/usecases/get_groups_usecase.dart';

part 'expense_details_bloc.freezed.dart';
part 'expense_details_event.dart';
part 'expense_details_state.dart';

@injectable
final class ExpenseDetailsBloc
    extends
        BaseBloc<
          ExpenseDetailsEvent,
          ExpenseDetailsState,
          ExpenseDetailsParams
        > {
  ExpenseDetailsBloc(
    this._getExpenseDetailsUseCase,
    this._deleteExpenseUseCase,
    this._getGroupsUseCase,
    this._getFriendsUseCase,
  ) : super(
        const ExpenseDetailsState.initial(
          store: ExpenseDetailsStateStore(),
        ),
      );

  final GetExpenseDetailsUseCase _getExpenseDetailsUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final GetGroupsUseCase _getGroupsUseCase;
  final GetFriendsUseCase _getFriendsUseCase;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_DeleteExpense>(_onDeleteExpense);
  }

  @override
  void started(ExpenseDetailsParams params) {
    add(
      ExpenseDetailsEvent.started(
        expenseId: params.expenseId,
        expense: params.expense,
      ),
    );
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<ExpenseDetailsState> emit,
  ) async {
    final initialExpense = event.expense;
    if (initialExpense != null) {
      emit(
        ExpenseDetailsState.onExpenseLoaded(
          store: state.store.copyWith(
            expenseId: event.expenseId,
            expense: initialExpense,
            loading: false,
          ),
          expense: initialExpense,
        ),
      );
    } else {
      emit(
        ExpenseDetailsState.initial(
          store: state.store.copyWith(
            expenseId: event.expenseId,
            loading: true,
          ),
        ),
      );
    }

    final groupsResult = await _getGroupsUseCase.call(const GetGroupsParams());
    final friendsResult = await _getFriendsUseCase.call(
      const GetFriendsParams(),
    );

    final groups = groupsResult.fold((_) => <Group>[], (p) => p.items);
    final friends = friendsResult.fold((_) => <Friend>[], (p) => p.items);

    final userNames = <String, String>{};
    for (final friend in friends) {
      final fId = friend.id;
      if (fId != null) {
        userNames[fId] = friend.name ?? friend.email ?? 'Friend';
      }
    }
    for (final group in groups) {
      for (final member in group.members) {
        final mId = member.userId;
        if (mId != null && !userNames.containsKey(mId)) {
          userNames[mId] = member.name ?? member.email ?? 'Member';
        }
      }
    }

    final result = await _getExpenseDetailsUseCase.call(event.expenseId);

    result.fold(
      (failure) {
        if (state.store.expense == null) {
          handleFailure(emit: emit, failure: failure);
        }
      },
      (expense) {
        for (final split in expense.splits) {
          if (split.name.isNotEmpty) {
            userNames[split.userId] = split.name;
          }
        }
        emit(
          ExpenseDetailsState.onExpenseLoaded(
            store: state.store.copyWith(
              loading: false,
              expense: expense,
              userNames: userNames,
            ),
            expense: expense,
          ),
        );
      },
    );
  }

  FutureOr<void> _onDeleteExpense(
    _DeleteExpense event,
    Emitter<ExpenseDetailsState> emit,
  ) async {
    emit(
      ExpenseDetailsState.changeLoaderState(
        store: state.store.copyWith(isDeleting: true, loading: true),
      ),
    );

    final result = await _deleteExpenseUseCase.call(
      DeleteExpenseParams(id: state.store.expenseId),
    );

    result.fold(
      (failure) {
        if (state.store.expense != null) {
          emit(
            ExpenseDetailsState.onExpenseLoaded(
              store: state.store.copyWith(isDeleting: false, loading: false),
              expense: state.store.expense!,
            ),
          );
        }
        handleFailure(emit: emit, failure: failure);
      },
      (_) => emit(
        ExpenseDetailsState.onExpenseDeleted(
          store: state.store.copyWith(isDeleting: false, loading: false),
        ),
      ),
    );
  }

  void deleteExpense() {
    add(const ExpenseDetailsEvent.deleteExpense());
  }
}
