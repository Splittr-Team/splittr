part of 'create_expense_bloc.dart';

@freezed
sealed class CreateExpenseState extends BaseState with _$CreateExpenseState {
  const CreateExpenseState._();

  const factory CreateExpenseState.initial({
    required CreateExpenseStateStore store,
  }) = Initial;

  const factory CreateExpenseState.onDraftUpdated({
    required CreateExpenseStateStore store,
  }) = OnDraftUpdated;

  const factory CreateExpenseState.onCreateSuccess({
    required CreateExpenseStateStore store,
    required Expense expense,
  }) = OnCreateSuccess;

  const factory CreateExpenseState.onUpdateSuccess({
    required CreateExpenseStateStore store,
    required Expense expense,
  }) = OnUpdateSuccess;

  const factory CreateExpenseState.onFailure({
    required CreateExpenseStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory CreateExpenseState.changeLoaderState({
    required CreateExpenseStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      CreateExpenseState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      CreateExpenseState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class CreateExpenseStateStore with _$CreateExpenseStateStore {
  const CreateExpenseStateStore({
    this.loading = false,
    this.isSubmitting = false,
    this.isLoadingMetadata = true,
    this.expenseId,
    this.description = '',
    this.amount = 0,
    this.currency = 'INR',
    this.paidBy = '',
    this.splitType = SplitType.equal,
    this.splits = const [],
    this.category,
    this.groupId,
    this.validationError,
    this.availableGroups = const [],
    this.availableFriends = const [],
    this.userNames = const {},
  });

  @override
  final bool loading;
  @override
  final bool isSubmitting;
  @override
  final bool isLoadingMetadata;
  @override
  final String? expenseId;
  @override
  final String description;
  @override
  final num amount;
  @override
  final String currency;
  @override
  final String paidBy;
  @override
  final SplitType splitType;
  @override
  final List<InputSplit> splits;
  @override
  final String? category;
  @override
  final String? groupId;
  @override
  final String? validationError;
  @override
  final List<Group> availableGroups;
  @override
  final List<Friend> availableFriends;
  @override
  final Map<String, String> userNames;

  bool get isEdit => expenseId != null && expenseId!.isNotEmpty;
  bool get isValid =>
      validationError == null &&
      description.trim().isNotEmpty &&
      amount > 0 &&
      paidBy.trim().isNotEmpty &&
      splits.isNotEmpty;
}

class CreateExpenseBlocParams extends Equatable {
  const CreateExpenseBlocParams({
    this.expense,
    this.groupId,
    this.currentUserId,
    this.defaultCurrency,
    this.participantUserIds = const [],
  });

  final Expense? expense;
  final String? groupId;
  final String? currentUserId;
  final String? defaultCurrency;
  final List<String> participantUserIds;

  @override
  List<Object?> get props => [
    expense,
    groupId,
    currentUserId,
    defaultCurrency,
    participantUserIds,
  ];
}
