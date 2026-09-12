import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/app_config/domain/stores/app_config_store.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/entities/input_split.dart';
import 'package:splittr/features/expenses/domain/entities/split.dart';
import 'package:splittr/features/expenses/domain/entities/split_type.dart';
import 'package:splittr/features/expenses/domain/usecases/create_expense_usecase.dart';
import 'package:splittr/features/expenses/domain/usecases/update_expense_usecase.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/domain/usecases/get_friends_usecase.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/usecases/get_groups_usecase.dart';

part 'create_expense_bloc.freezed.dart';
part 'create_expense_event.dart';
part 'create_expense_state.dart';

@injectable
final class CreateExpenseBloc
    extends
        BaseBloc<
          CreateExpenseEvent,
          CreateExpenseState,
          CreateExpenseBlocParams
        > {
  CreateExpenseBloc(
    this._createExpenseUseCase,
    this._updateExpenseUseCase,
    this._getGroupsUseCase,
    this._getFriendsUseCase,
    this._appConfigStore,
  ) : super(
        const CreateExpenseState.initial(
          store: CreateExpenseStateStore(),
        ),
      );

  final CreateExpenseUseCase _createExpenseUseCase;
  final UpdateExpenseUseCase _updateExpenseUseCase;
  final GetGroupsUseCase _getGroupsUseCase;
  final GetFriendsUseCase _getFriendsUseCase;
  final AppConfigStore _appConfigStore;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_AmountChanged>(_onAmountChanged);
    on<_CurrencyChanged>(_onCurrencyChanged);
    on<_PaidByChanged>(_onPaidByChanged);
    on<_SplitTypeChanged>(_onSplitTypeChanged);
    on<_SplitsChanged>(_onSplitsChanged);
    on<_ParticipantToggled>(_onParticipantToggled);
    on<_SplitAmountChanged>(_onSplitAmountChanged);
    on<_SplitPercentageChanged>(_onSplitPercentageChanged);
    on<_CategoryChanged>(_onCategoryChanged);
    on<_GroupIdChanged>(_onGroupIdChanged);
    on<_GroupSelected>(_onGroupSelected);
    on<_ParticipantAdded>(_onParticipantAdded);
    on<_Submit>(_onSubmit);
  }

  @override
  void started(CreateExpenseBlocParams params) {
    add(CreateExpenseEvent.started(params));
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<CreateExpenseState> emit,
  ) async {
    final groupsResult = await _getGroupsUseCase.call(const GetGroupsParams());
    final friendsResult = await _getFriendsUseCase.call(
      const GetFriendsParams(),
    );

    final groups = groupsResult.fold((_) => <Group>[], (p) => p.items);
    final friends = friendsResult.fold((_) => <Friend>[], (p) => p.items);

    final currentUserId = event.params.currentUserId ?? '';
    final userNames = <String, String>{};
    if (currentUserId.isNotEmpty) {
      userNames[currentUserId] = 'You';
    }
    for (final friend in friends) {
      final fId = friend.id;
      if (fId != null && fId != currentUserId) {
        userNames[fId] = friend.name ?? friend.email ?? 'Friend';
      }
    }
    for (final group in groups) {
      for (final member in group.members) {
        final mId = member.userId;
        if (mId != null &&
            mId != currentUserId &&
            !userNames.containsKey(mId)) {
          userNames[mId] = member.name ?? member.email ?? 'Member';
        }
      }
    }

    final expense = event.params.expense;
    if (expense != null) {
      final splitType = expense.splitType ?? SplitType.equal;
      final splits = _mapDomainSplitsToInputSplits(
        splits: expense.splits,
        splitType: splitType,
        totalAmount: expense.amount,
      );

      final error = _validateSplits(
        splitType: splitType,
        amount: expense.amount,
        splits: splits,
      );

      for (final split in expense.splits) {
        if (split.userId == currentUserId) {
          userNames[split.userId] = 'You';
        } else if (split.name.isNotEmpty &&
            !userNames.containsKey(split.userId)) {
          userNames[split.userId] = split.name;
        }
      }

      emit(
        CreateExpenseState.onDraftUpdated(
          store: state.store.copyWith(
            isLoadingMetadata: false,
            expenseId: expense.id,
            description: expense.description,
            amount: expense.amount,
            currency: expense.currency,
            paidBy: expense.paidBy,
            splitType: splitType,
            splits: splits,
            category: expense.category,
            groupId: expense.groupId,
            validationError: error,
            availableGroups: groups,
            availableFriends: friends,
            userNames: userNames,
          ),
        ),
      );
    } else {
      final participants = <String>{...event.params.participantUserIds};
      final groupId = event.params.groupId;

      if (groupId != null && participants.isEmpty) {
        final group = groups.where((g) => g.id == groupId).firstOrNull;
        if (group != null) {
          participants.addAll(
            group.members.map((m) => m.userId).whereType<String>(),
          );
        }
      }

      if (currentUserId.isNotEmpty) {
        participants.add(currentUserId);
      }

      final splits = participants
          .map((id) => InputSplit.equal(userId: id))
          .toList();

      final paidBy = currentUserId.isNotEmpty
          ? currentUserId
          : (participants.isNotEmpty ? participants.first : '');

      final defaultCurrency =
          event.params.defaultCurrency ??
          _appConfigStore.userPreferredCurrency ??
          _appConfigStore.defaultCurrency;

      emit(
        CreateExpenseState.onDraftUpdated(
          store: state.store.copyWith(
            isLoadingMetadata: false,
            currency: defaultCurrency,
            groupId: groupId,
            paidBy: paidBy,
            splits: splits,
            availableGroups: groups,
            availableFriends: friends,
            userNames: userNames,
          ),
        ),
      );
    }
  }

  void _onDescriptionChanged(
    _DescriptionChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(description: event.description),
      ),
    );
  }

  void _onAmountChanged(
    _AmountChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    final splits = _recalculateSplits(
      newSplitType: state.store.splitType,
      amount: event.amount,
      currentSplits: state.store.splits,
    );
    final error = _validateSplits(
      splitType: state.store.splitType,
      amount: event.amount,
      splits: splits,
    );

    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(
          amount: event.amount,
          splits: splits,
          validationError: error,
        ),
      ),
    );
  }

  void _onCurrencyChanged(
    _CurrencyChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(currency: event.currency),
      ),
    );
  }

  void _onPaidByChanged(
    _PaidByChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(paidBy: event.paidBy),
      ),
    );
  }

  void _onSplitTypeChanged(
    _SplitTypeChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    final splits = _recalculateSplits(
      newSplitType: event.splitType,
      amount: state.store.amount,
      currentSplits: state.store.splits,
    );
    final error = _validateSplits(
      splitType: event.splitType,
      amount: state.store.amount,
      splits: splits,
    );

    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(
          splitType: event.splitType,
          splits: splits,
          validationError: error,
        ),
      ),
    );
  }

  void _onSplitsChanged(
    _SplitsChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    final error = _validateSplits(
      splitType: state.store.splitType,
      amount: state.store.amount,
      splits: event.splits,
    );

    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(
          splits: event.splits,
          validationError: error,
        ),
      ),
    );
  }

  void _onParticipantToggled(
    _ParticipantToggled event,
    Emitter<CreateExpenseState> emit,
  ) {
    final currentSplits = List<InputSplit>.from(state.store.splits);
    final existingIndex = currentSplits.indexWhere(
      (s) => s.userId == event.userId,
    );

    if (existingIndex >= 0) {
      currentSplits.removeAt(existingIndex);
    } else {
      switch (state.store.splitType) {
        case SplitType.equal:
          currentSplits.add(InputSplit.equal(userId: event.userId));
        case SplitType.exact:
          currentSplits.add(InputSplit.exact(userId: event.userId, amount: 0));
        case SplitType.percentage:
          currentSplits.add(
            InputSplit.percentage(userId: event.userId, percentage: 0),
          );
      }
    }

    final splits = _recalculateSplits(
      newSplitType: state.store.splitType,
      amount: state.store.amount,
      currentSplits: currentSplits,
    );
    final error = _validateSplits(
      splitType: state.store.splitType,
      amount: state.store.amount,
      splits: splits,
    );

    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(
          splits: splits,
          validationError: error,
        ),
      ),
    );
  }

  void _onSplitAmountChanged(
    _SplitAmountChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    final updatedSplits = state.store.splits.map((s) {
      if (s.userId == event.userId) {
        return InputSplit.exact(userId: event.userId, amount: event.amount);
      }
      return s;
    }).toList();

    final error = _validateSplits(
      splitType: SplitType.exact,
      amount: state.store.amount,
      splits: updatedSplits,
    );

    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(
          splits: updatedSplits,
          validationError: error,
        ),
      ),
    );
  }

  void _onSplitPercentageChanged(
    _SplitPercentageChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    final updatedSplits = state.store.splits.map((s) {
      if (s.userId == event.userId) {
        return InputSplit.percentage(
          userId: event.userId,
          percentage: event.percentage,
        );
      }
      return s;
    }).toList();

    final error = _validateSplits(
      splitType: SplitType.percentage,
      amount: state.store.amount,
      splits: updatedSplits,
    );

    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(
          splits: updatedSplits,
          validationError: error,
        ),
      ),
    );
  }

  void _onCategoryChanged(
    _CategoryChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(category: event.category),
      ),
    );
  }

  void _onGroupIdChanged(
    _GroupIdChanged event,
    Emitter<CreateExpenseState> emit,
  ) {
    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(groupId: event.groupId),
      ),
    );
  }

  void _onGroupSelected(
    _GroupSelected event,
    Emitter<CreateExpenseState> emit,
  ) {
    final groupId = event.groupId;
    if (groupId != null && groupId.isNotEmpty) {
      final group = state.store.availableGroups
          .where((g) => g.id == groupId)
          .firstOrNull;
      final memberIds = <String>{};
      if (group != null) {
        memberIds.addAll(
          group.members.map((m) => m.userId).whereType<String>(),
        );
      }
      if (state.store.paidBy.isNotEmpty) {
        memberIds.add(state.store.paidBy);
      }

      final splits = memberIds
          .map((id) => InputSplit.equal(userId: id))
          .toList();

      final error = _validateSplits(
        splitType: state.store.splitType,
        amount: state.store.amount,
        splits: splits,
      );

      emit(
        CreateExpenseState.onDraftUpdated(
          store: state.store.copyWith(
            groupId: groupId,
            splits: splits,
            validationError: error,
          ),
        ),
      );
    } else {
      emit(
        CreateExpenseState.onDraftUpdated(
          store: state.store.copyWith(
            groupId: null,
          ),
        ),
      );
    }
  }

  void _onParticipantAdded(
    _ParticipantAdded event,
    Emitter<CreateExpenseState> emit,
  ) {
    final splits = [...state.store.splits];
    final userNames = {...state.store.userNames};
    if (event.name != null && event.name!.isNotEmpty) {
      userNames[event.userId] = event.name!;
    }

    if (!splits.any((s) => s.userId == event.userId)) {
      splits.add(InputSplit.equal(userId: event.userId));
    }

    final error = _validateSplits(
      splitType: state.store.splitType,
      amount: state.store.amount,
      splits: splits,
    );

    emit(
      CreateExpenseState.onDraftUpdated(
        store: state.store.copyWith(
          splits: splits,
          userNames: userNames,
          validationError: error,
        ),
      ),
    );
  }

  FutureOr<void> _onSubmit(
    _Submit event,
    Emitter<CreateExpenseState> emit,
  ) async {
    final store = state.store;
    final validationError = _validateSplits(
      splitType: store.splitType,
      amount: store.amount,
      splits: store.splits,
    );

    if (validationError != null) {
      emit(
        CreateExpenseState.onDraftUpdated(
          store: store.copyWith(validationError: validationError),
        ),
      );
      return;
    }

    if (store.description.trim().isEmpty) {
      emit(
        CreateExpenseState.onDraftUpdated(
          store: store.copyWith(
            validationError: 'Description is required',
          ),
        ),
      );
      return;
    }

    if (store.paidBy.trim().isEmpty) {
      emit(
        CreateExpenseState.onDraftUpdated(
          store: store.copyWith(
            validationError: 'Payer is required',
          ),
        ),
      );
      return;
    }

    final maxAmount = _appConfigStore.limits.maxExpenseAmount;
    if (store.amount > maxAmount) {
      emit(
        CreateExpenseState.onDraftUpdated(
          store: store.copyWith(
            validationError: 'Expense amount cannot exceed $maxAmount',
          ),
        ),
      );
      return;
    }

    emit(
      CreateExpenseState.changeLoaderState(
        store: state.store.copyWith(isSubmitting: true, loading: true),
      ),
    );

    if (store.isEdit) {
      final result = await _updateExpenseUseCase.call(
        UpdateExpenseParams(
          id: store.expenseId!,
          description: store.description,
          amount: store.amount,
          currency: store.currency,
          category: store.category,
          splitType: store.splitType,
          splits: store.splits,
        ),
      );

      result.fold(
        (failure) {
          emit(
            CreateExpenseState.onDraftUpdated(
              store: state.store.copyWith(isSubmitting: false, loading: false),
            ),
          );
          handleFailure(emit: emit, failure: failure);
        },
        (expense) => emit(
          CreateExpenseState.onUpdateSuccess(
            store: state.store.copyWith(isSubmitting: false, loading: false),
            expense: expense,
          ),
        ),
      );
    } else {
      final result = await _createExpenseUseCase.call(
        CreateExpenseParams(
          description: store.description,
          amount: store.amount,
          currency: store.currency,
          paidBy: store.paidBy,
          splitType: store.splitType,
          splits: store.splits,
          category: store.category,
          groupId: store.groupId,
        ),
      );

      result.fold(
        (failure) {
          emit(
            CreateExpenseState.onDraftUpdated(
              store: state.store.copyWith(isSubmitting: false, loading: false),
            ),
          );
          handleFailure(emit: emit, failure: failure);
        },
        (expense) => emit(
          CreateExpenseState.onCreateSuccess(
            store: state.store.copyWith(isSubmitting: false, loading: false),
            expense: expense,
          ),
        ),
      );
    }
  }

  void descriptionChanged({required String description}) {
    add(CreateExpenseEvent.descriptionChanged(description: description));
  }

  void amountChanged({required num amount}) {
    add(CreateExpenseEvent.amountChanged(amount: amount));
  }

  void currencyChanged({required String currency}) {
    add(CreateExpenseEvent.currencyChanged(currency: currency));
  }

  void paidByChanged({required String paidBy}) {
    add(CreateExpenseEvent.paidByChanged(paidBy: paidBy));
  }

  void splitTypeChanged({required SplitType splitType}) {
    add(CreateExpenseEvent.splitTypeChanged(splitType: splitType));
  }

  void splitsChanged({required List<InputSplit> splits}) {
    add(CreateExpenseEvent.splitsChanged(splits: splits));
  }

  void participantToggled({required String userId}) {
    add(CreateExpenseEvent.participantToggled(userId: userId));
  }

  void splitAmountChanged({
    required String userId,
    required num amount,
  }) {
    add(
      CreateExpenseEvent.splitAmountChanged(
        userId: userId,
        amount: amount,
      ),
    );
  }

  void splitPercentageChanged({
    required String userId,
    required num percentage,
  }) {
    add(
      CreateExpenseEvent.splitPercentageChanged(
        userId: userId,
        percentage: percentage,
      ),
    );
  }

  void categoryChanged({String? category}) {
    add(CreateExpenseEvent.categoryChanged(category: category));
  }

  void groupIdChanged({String? groupId}) {
    add(CreateExpenseEvent.groupIdChanged(groupId: groupId));
  }

  void groupSelected({String? groupId}) {
    add(CreateExpenseEvent.groupSelected(groupId: groupId));
  }

  void participantAdded({required String userId, String? name}) {
    add(CreateExpenseEvent.participantAdded(userId: userId, name: name));
  }

  void submit() {
    add(const CreateExpenseEvent.submit());
  }

  String? _validateSplits({
    required SplitType splitType,
    required num amount,
    required List<InputSplit> splits,
  }) {
    if (splits.isEmpty) {
      return 'At least one participant is required';
    }
    if (amount <= 0) {
      return 'Amount must be greater than zero';
    }

    switch (splitType) {
      case SplitType.equal:
        return null;
      case SplitType.exact:
        final total = splits.fold<num>(
          0,
          (sum, s) => sum + (s is ExactInputSplit ? s.amount : 0),
        );
        if ((total - amount).abs() > 0.01) {
          return 'Split amounts sum does not match expense amount';
        }
        return null;
      case SplitType.percentage:
        final total = splits.fold<num>(
          0,
          (sum, s) => sum + (s is PercentageInputSplit ? s.percentage : 0),
        );
        if ((total - 100).abs() > 0.01) {
          return 'Split percentages sum must equal 100%';
        }
        return null;
    }
  }

  List<InputSplit> _recalculateSplits({
    required SplitType newSplitType,
    required num amount,
    required List<InputSplit> currentSplits,
  }) {
    if (currentSplits.isEmpty) return currentSplits;

    final userIds = currentSplits.map((s) => s.userId).toList();
    final count = userIds.length;

    switch (newSplitType) {
      case SplitType.equal:
        return userIds.map((id) => InputSplit.equal(userId: id)).toList();
      case SplitType.exact:
        final share = count > 0 ? (amount / count) : 0;
        return userIds
            .map((id) => InputSplit.exact(userId: id, amount: share))
            .toList();
      case SplitType.percentage:
        final pct = count > 0 ? (100.0 / count) : 0;
        return userIds
            .map((id) => InputSplit.percentage(userId: id, percentage: pct))
            .toList();
    }
  }

  List<InputSplit> _mapDomainSplitsToInputSplits({
    required List<Split> splits,
    required SplitType splitType,
    required num totalAmount,
  }) {
    return splits.map((s) {
      switch (splitType) {
        case SplitType.equal:
          return InputSplit.equal(userId: s.userId);
        case SplitType.exact:
          return InputSplit.exact(userId: s.userId, amount: s.amount);
        case SplitType.percentage:
          final pct = s is PercentageSplit
              ? s.splitValue
              : (totalAmount > 0 ? (s.amount / totalAmount * 100) : 0);
          return InputSplit.percentage(userId: s.userId, percentage: pct);
      }
    }).toList();
  }
}
