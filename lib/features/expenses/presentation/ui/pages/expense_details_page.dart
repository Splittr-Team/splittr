import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Split;
import 'package:intl/intl.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/presentation/blocs/expense_details/expense_details_bloc.dart';

class ExpenseDetailsPage
    extends BasePage<ExpenseDetailsBloc, ExpenseDetailsState> {
  const ExpenseDetailsPage({
    required this.expenseId,
    this.expense,
    super.key,
  });

  final String expenseId;
  final Expense? expense;

  @override
  ExpenseDetailsBloc createBloc() =>
      getIt<ExpenseDetailsBloc>()
        ..started(ExpenseDetailsParams(expenseId: expenseId, expense: expense));

  @override
  bool showLoading(ExpenseDetailsState state) => state.store.isDeleting;

  @override
  void handleStateChange(BuildContext context, ExpenseDetailsState state) {
    return switch (state) {
      OnExpenseDeleted _ => {
        AppSnackBar.show(
          context,
          message: 'Expense deleted successfully',
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

  IconData _getCategoryIcon(String? category) {
    return switch (category?.toLowerCase()) {
      'food' ||
      'dining' ||
      'groceries' ||
      'restaurant' => Icons.restaurant_rounded,
      'shopping' || 'clothes' => Icons.shopping_bag_rounded,
      'transport' ||
      'travel' ||
      'taxi' ||
      'fuel' => Icons.directions_car_rounded,
      'entertainment' || 'movies' || 'games' => Icons.movie_rounded,
      'bills' || 'utilities' || 'rent' => Icons.receipt_rounded,
      'home' || 'household' => Icons.home_rounded,
      'drinks' || 'bar' || 'coffee' => Icons.local_cafe_rounded,
      _ => Icons.receipt_long_rounded,
    };
  }

  void _showDeleteConfirmation(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text(
            'Are you sure you want to delete this expense? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                getBloc<ExpenseDetailsBloc>(context).deleteExpense();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: context.colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<ExpenseDetailsBloc, ExpenseDetailsState>(
      builder: (context, state) {
        final expense = state.store.expense;

        if (expense == null) {
          return const _ExpenseDetailsShimmerSkeleton();
        }

        final dateFormat = DateFormat.yMMMMd().add_jm();
        final formattedDate = dateFormat.format(expense.spentAt);

        final authUser = getIt<AuthBloc>().state.user;
        final currentUserId =
            authUser?.id ?? getIt<FirebaseAuth>().currentUser?.uid;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Expense Details'),
            actions: [
              IconButton(
                icon: const AppIcon.md(Icons.edit_outlined),
                onPressed: () {
                  unawaited(
                    AddExpenseRoute(
                      args: AddExpenseArgs(
                        expense: expense,
                        groupId: expense.groupId,
                        participantUserIds: expense.splits
                            .map((s) => s.userId)
                            .toList(),
                      ),
                    ).push<void>(context),
                  );
                },
              ),
              IconButton(
                icon: const AppIcon.md(Icons.delete_outline_rounded),
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                AppCard.outlined(
                  color: context.colorScheme.surfaceContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: context.colorScheme.primaryContainer,
                          foregroundColor:
                              context.colorScheme.onPrimaryContainer,
                          child: AppIcon.lg(_getCategoryIcon(expense.category)),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppText.headlineSmall(
                          expense.description,
                          color: context.colorScheme.onSurface,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppText.headlineMedium(
                          '${expense.currency} '
                          '${expense.amount.toStringAsFixed(2)}',
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppText.bodySmall(
                          formattedDate,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Payer Card
                Builder(
                  builder: (context) {
                    final isCurrentUserPaid = expense.paidBy == currentUserId;
                    final resolvedPaidByName =
                        state.store.userNames[expense.paidBy];
                    final payerSplit = expense.splits
                        .where((s) => s.userId == expense.paidBy)
                        .firstOrNull;
                    final payerSplitName =
                        payerSplit != null && payerSplit.name.isNotEmpty
                        ? payerSplit.name
                        : null;
                    final resolvedName = resolvedPaidByName ?? payerSplitName;
                    final payerDisplayName = isCurrentUserPaid
                        ? (resolvedName != null ? '$resolvedName (You)' : 'You')
                        : (resolvedName ??
                              (expense.paidBy.isNotEmpty
                                  ? 'Member'
                                  : 'Unknown'));

                    return AppCard.outlined(
                      color: context.colorScheme.surfaceContainer,
                      child: ListTile(
                        leading: const AppIcon.md(Icons.person_rounded),
                        title: AppText.bodySmall(
                          'Paid by',
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        subtitle: AppText.titleMedium(
                          payerDisplayName,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Splits Breakdown
                AppText.titleMedium(
                  'Split Breakdown (${expense.splits.length} people)',
                  color: context.colorScheme.onSurface,
                ),
                const SizedBox(height: AppSpacing.sm),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expense.splits.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final split = expense.splits[index];
                    final isCurrentUser = split.userId == currentUserId;
                    final resolvedName =
                        state.store.userNames[split.userId] ??
                        (split.name.isNotEmpty ? split.name : null);
                    final displayName = isCurrentUser
                        ? (resolvedName != null ? '$resolvedName (You)' : 'You')
                        : (resolvedName ?? 'Participant');
                    final initials = displayName.trim().isNotEmpty
                        ? displayName
                              .trim()
                              .split(' ')
                              .where((w) => w.isNotEmpty)
                              .map((l) => l[0])
                              .take(2)
                              .join()
                              .toUpperCase()
                        : '?';

                    return AppCard.outlined(
                      color: context.colorScheme.surfaceContainerLow,
                      child: ListTile(
                        leading: AppAvatar(initials: initials),
                        title: AppText.bodyMedium(
                          displayName,
                          color: context.colorScheme.onSurface,
                        ),
                        trailing: AppText.titleMedium(
                          '${expense.currency} '
                          '${split.amount.toStringAsFixed(2)}',
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExpenseDetailsShimmerSkeleton extends StatelessWidget {
  const _ExpenseDetailsShimmerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppCard.outlined(
              color: context.colorScheme.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    AppShimmer(
                      width: 64,
                      height: 64,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const AppShimmer(
                      width: 140,
                      height: 24,
                      borderRadius: AppBorderRadius.xs,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const AppShimmer(
                      width: 100,
                      height: 32,
                      borderRadius: AppBorderRadius.xs,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const AppShimmer(
                      width: 80,
                      height: 14,
                      borderRadius: AppBorderRadius.xs,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard.outlined(
              color: context.colorScheme.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    AppShimmer(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const AppShimmer(
                      width: 120,
                      height: 18,
                      borderRadius: AppBorderRadius.xs,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppShimmer(
              width: double.infinity,
              height: 160,
              borderRadius: AppBorderRadius.md,
            ),
          ],
        ),
      ),
    );
  }
}
