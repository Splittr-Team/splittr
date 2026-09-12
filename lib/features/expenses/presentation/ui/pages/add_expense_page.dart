import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/app_config/domain/stores/app_config_store.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/expenses/presentation/blocs/create_expense/create_expense_bloc.dart';
import 'package:splittr/features/expenses/presentation/ui/widgets/payer_selector_bottom_sheet.dart';
import 'package:splittr/features/expenses/presentation/ui/widgets/split_members_list.dart';
import 'package:splittr/features/expenses/presentation/ui/widgets/split_type_selector.dart';
import 'package:splittr/features/profile/presentation/ui/widgets/currency_picker_bottom_sheet.dart';

class AddExpensePage extends BasePage<CreateExpenseBloc, CreateExpenseState> {
  const AddExpensePage({
    this.args,
    super.key,
  });

  final AddExpenseArgs? args;

  @override
  CreateExpenseBloc createBloc() {
    final authUser = getIt<AuthBloc>().state.user;
    final currentUserId =
        authUser?.id ?? getIt<FirebaseAuth>().currentUser?.uid;
    final defaultCurrency =
        args?.expense?.currency ??
        authUser?.defaultCurrency ??
        getIt<AppConfigStore>().userPreferredCurrency ??
        getIt<AppConfigStore>().defaultCurrency;

    return getIt<CreateExpenseBloc>()..started(
      CreateExpenseBlocParams(
        expense: args?.expense,
        groupId: args?.groupId,
        currentUserId: currentUserId,
        defaultCurrency: defaultCurrency,
        participantUserIds: args?.participantUserIds ?? [],
      ),
    );
  }

  @override
  bool showLoading(CreateExpenseState state) => state.store.isSubmitting;

  @override
  void handleStateChange(BuildContext context, CreateExpenseState state) {
    return switch (state) {
      OnCreateSuccess(:final expense) => {
        AppSnackBar.show(
          context,
          message: 'Expense "${expense.description}" created!',
        ),
        RouteHandler.pop<void>(context),
      },
      OnUpdateSuccess(:final expense) => {
        AppSnackBar.show(
          context,
          message: 'Expense "${expense.description}" updated!',
        ),
        RouteHandler.pop<void>(context),
      },
      OnFailure(:final failure) => AppSnackBar.show(
        context,
        message: failure.message,
      ),
      _ => () {},
    };
  }

  @override
  Widget buildPage(BuildContext context) {
    return _AddExpenseForm(args: args);
  }
}

class _AddExpenseForm extends StatefulWidget {
  const _AddExpenseForm({this.args});

  final AddExpenseArgs? args;

  @override
  State<_AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<_AddExpenseForm> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;

  static const List<String> _defaultCategories = [
    'General',
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Utilities',
  ];

  @override
  void initState() {
    super.initState();
    final expense = widget.args?.expense;
    _descriptionController = TextEditingController(
      text: expense?.description ?? '',
    );
    _amountController = TextEditingController(
      text: (expense != null && expense.amount > 0)
          ? expense.amount.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Widget _buildChipsShimmer(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: AppShimmer(
              child: Container(
                width: 80,
                height: 32,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = getIt<AuthBloc>().state.user;
    final currentUserId =
        authUser?.id ?? getIt<FirebaseAuth>().currentUser?.uid;

    final configCategories = getIt<AppConfigStore>().categories;
    final categories = configCategories.isNotEmpty
        ? configCategories.map((c) => c.name).toList()
        : _defaultCategories;

    return BlocConsumer<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (_descriptionController.text.isEmpty &&
            state.store.description.isNotEmpty) {
          _descriptionController.text = state.store.description;
        }
        if (_amountController.text.isEmpty && state.store.amount > 0) {
          _amountController.text = state.store.amount.toString();
        }
      },
      builder: (context, state) {
        final bloc = getBloc<CreateExpenseBloc>(context);
        final store = state.store;
        final isEdit = store.isEdit;

        final payerItems = store.splits.map((s) {
          final isCurrentUser =
              s.userId == currentUserId ||
              (store.splits.length == 1 && s.userId == store.paidBy);
          final displayName = isCurrentUser
              ? 'You'
              : (store.userNames[s.userId] ?? s.userId);
          return PayerItem(
            id: s.userId,
            name: displayName,
          );
        }).toList();

        if (payerItems.isEmpty && store.paidBy.isNotEmpty) {
          final isCurrentUser = store.paidBy == currentUserId;
          final displayName = isCurrentUser
              ? 'You'
              : (store.userNames[store.paidBy] ?? 'You');
          payerItems.add(PayerItem(id: store.paidBy, name: displayName));
        }

        final selectedPayer = payerItems.firstWhere(
          (p) => p.id == store.paidBy,
          orElse: () => PayerItem(
            id: store.paidBy.isNotEmpty ? store.paidBy : 'Select Payer',
            name:
                store.userNames[store.paidBy] ??
                (store.paidBy.isNotEmpty ? store.paidBy : 'Select Payer'),
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(isEdit ? 'Edit Expense' : 'Add Expense'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Group selector
                if (widget.args?.groupId == null) ...[
                  AppText.labelMedium(
                    'Group',
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (store.isLoadingMetadata)
                    _buildChipsShimmer(context)
                  else if (store.availableGroups.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.xs,
                            ),
                            child: ChoiceChip(
                              label: const Text('No Group'),
                              selected: store.groupId == null,
                              onSelected: (selected) {
                                if (selected) bloc.groupSelected();
                              },
                            ),
                          ),
                          ...store.availableGroups.map((group) {
                            final isSelected = store.groupId == group.id;
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.xs,
                              ),
                              child: ChoiceChip(
                                label: Text(group.name ?? 'Group'),
                                selected: isSelected,
                                onSelected: (selected) {
                                  bloc.groupSelected(
                                    groupId: selected ? group.id : null,
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Friends selector when no group
                if (store.groupId == null) ...[
                  AppText.labelMedium(
                    'Add Friends to Split',
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (store.isLoadingMetadata)
                    _buildChipsShimmer(context)
                  else if (store.availableFriends.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: store.availableFriends.map((friend) {
                          final isIncluded = store.splits.any(
                            (s) => s.userId == friend.id,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.xs,
                            ),
                            child: FilterChip(
                              label: Text(
                                friend.name ?? friend.email ?? 'Friend',
                              ),
                              selected: isIncluded,
                              onSelected: (selected) {
                                if (selected) {
                                  bloc.participantAdded(
                                    userId: friend.id!,
                                    name: friend.name,
                                  );
                                } else {
                                  bloc.participantToggled(userId: friend.id!);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Description field
                AppTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText: 'What was this for?',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: AppIcon.md(Icons.description_outlined),
                  ),
                  onChanged: (val) => bloc.descriptionChanged(description: val),
                ),
                const SizedBox(height: AppSpacing.md),

                // Amount field
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      child: InkWell(
                        onTap: () {
                          unawaited(
                            AppBottomSheet.show<void>(
                              context: context,
                              title: 'Select Currency',
                              child: CurrencyPickerBottomSheet(
                                selectedCurrency: store.currency,
                                onCurrencySelected: (val) =>
                                    bloc.currencyChanged(currency: val),
                              ),
                            ),
                          );
                        },
                        child: IgnorePointer(
                          child: AppTextField(
                            key: ValueKey(store.currency),
                            initialValue: store.currency,
                            labelText: 'Currency',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        controller: _amountController,
                        labelText: 'Amount',
                        hintText: '0.00',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: AppIcon.md(Icons.attach_money_rounded),
                        ),
                        onChanged: (val) {
                          final parsed = num.tryParse(val) ?? 0;
                          bloc.amountChanged(amount: parsed);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Category chips
                AppText.labelMedium(
                  'Category',
                  color: context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.xs),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = store.category == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            bloc.categoryChanged(
                              category: selected ? cat : null,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Paid By selector tile
                AppCard.outlined(
                  color: context.colorScheme.surfaceContainer,
                  child: ListTile(
                    leading: const AppIcon.md(Icons.person_rounded),
                    title: AppText.bodyMedium(
                      'Paid by',
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    subtitle: AppText.titleMedium(
                      selectedPayer.name,
                      color: context.colorScheme.onSurface,
                    ),
                    trailing: const AppIcon.md(Icons.chevron_right_rounded),
                    onTap: () {
                      unawaited(
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (_) => PayerSelectorBottomSheet(
                            payers: payerItems,
                            selectedPayerId: store.paidBy,
                            onPayerSelected: (userId) {
                              bloc.paidByChanged(paidBy: userId);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Split Type Selector
                AppText.titleSmall(
                  'Split Type',
                  color: context.colorScheme.onSurface,
                ),
                const SizedBox(height: AppSpacing.xs),
                SplitTypeSelector(
                  selectedType: store.splitType,
                  onTypeChanged: (type) =>
                      bloc.splitTypeChanged(splitType: type),
                ),
                const SizedBox(height: AppSpacing.md),

                // Split members list
                if (payerItems.isNotEmpty)
                  SplitMembersList(
                    members: payerItems,
                    splitType: store.splitType,
                    splits: store.splits,
                    totalAmount: store.amount,
                    currency: store.currency,
                    onParticipantToggled: (userId) =>
                        bloc.participantToggled(userId: userId),
                    onSplitAmountChanged: (userId, amount) =>
                        bloc.splitAmountChanged(
                          userId: userId,
                          amount: amount,
                        ),
                    onSplitPercentageChanged: (userId, pct) =>
                        bloc.splitPercentageChanged(
                          userId: userId,
                          percentage: pct,
                        ),
                  ),

                // Validation error display
                if (store.validationError != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: context.colorScheme.errorContainer,
                      borderRadius: AppBorderRadius.md,
                    ),
                    child: Row(
                      children: [
                        AppIcon.sm(
                          Icons.error_outline_rounded,
                          color: context.colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: AppText.bodySmall(
                            store.validationError!,
                            color: context.colorScheme.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: context.colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: AppButton.primary(
                text: isEdit ? 'Save Changes' : 'Save Expense',
                onPressed: store.isValid ? bloc.submit : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
