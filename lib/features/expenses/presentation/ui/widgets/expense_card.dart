import 'package:flutter/material.dart' hide Split;
import 'package:intl/intl.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/entities/split.dart';

enum ExpenseBalanceStatus {
  lent,
  borrowed,
  notInvolved,
  settled,
}

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    required this.expense,
    this.currentUserId,
    this.onTap,
    this.trailing,
    super.key,
  });

  final Expense expense;
  final String? currentUserId;
  final VoidCallback? onTap;
  final Widget? trailing;

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

  (ExpenseBalanceStatus, String, num) _calculateBalanceState() {
    if (expense.isPayment) {
      return (ExpenseBalanceStatus.settled, 'Settled', 0);
    }

    if (currentUserId == null) {
      return (ExpenseBalanceStatus.notInvolved, '', 0);
    }

    final isPayer = expense.paidBy == currentUserId;
    Split? userSplit;
    for (final split in expense.splits) {
      if (split.userId == currentUserId) {
        userSplit = split;
        break;
      }
    }

    if (isPayer) {
      final userAmount = userSplit?.amount ?? 0;
      final lentAmount = expense.amount - userAmount;
      if (lentAmount > 0) {
        return (ExpenseBalanceStatus.lent, 'you lent', lentAmount);
      }
      return (ExpenseBalanceStatus.lent, 'you paid', expense.amount);
    }

    if (userSplit != null) {
      return (
        ExpenseBalanceStatus.borrowed,
        'you borrowed',
        userSplit.amount,
      );
    }

    return (ExpenseBalanceStatus.notInvolved, 'not involved', 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.colorScheme.brightness == Brightness.dark;
    final (status, statusLabel, statusAmount) = _calculateBalanceState();
    final dateFormat = DateFormat.MMMd();
    final formattedDate = dateFormat.format(expense.spentAt);
    final formattedTotal =
        '${expense.currency} ${expense.amount.toStringAsFixed(2)}';

    Color statusColor;
    switch (status) {
      case ExpenseBalanceStatus.lent:
        statusColor = isDark
            ? Colors.greenAccent.shade400
            : Colors.green.shade700;
      case ExpenseBalanceStatus.borrowed:
        statusColor = context.colorScheme.error;
      case ExpenseBalanceStatus.notInvolved:
      case ExpenseBalanceStatus.settled:
        statusColor = context.colorScheme.onSurfaceVariant.withValues(
          alpha: 0.7,
        );
    }

    return AppCard.outlined(
      color: context.colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: AppBorderRadius.lg,
        onTap:
            onTap ??
            () => ExpenseDetailsRoute(
              expenseId: expense.id,
              expense: expense,
            ).push<void>(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: context.colorScheme.onSurface.withValues(
                  alpha: 0.08,
                ),
                foregroundColor: context.colorScheme.onSurfaceVariant,
                child: AppIcon.md(_getCategoryIcon(expense.category)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.titleMedium(
                      expense.description,
                      color: context.colorScheme.onSurface,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText.bodyMedium(
                      '$formattedDate • $formattedTotal',
                      color: context.colorScheme.onSurfaceVariant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              if (currentUserId != null &&
                  status != ExpenseBalanceStatus.notInvolved &&
                  status != ExpenseBalanceStatus.settled) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.labelSmall(
                      statusLabel,
                      color: statusColor,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText.titleMedium(
                      '${expense.currency} ${statusAmount.toStringAsFixed(2)}',
                      color: statusColor,
                    ),
                  ],
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.labelSmall(
                      statusLabel.isNotEmpty ? statusLabel : 'total',
                      color: statusColor,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText.titleMedium(
                      formattedTotal,
                      color: context.colorScheme.onSurface,
                    ),
                  ],
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseCardShimmer extends StatelessWidget {
  const ExpenseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard.outlined(
      color: context.colorScheme.surfaceContainer,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            AppShimmer.circle(size: 44),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppShimmer(
                    width: 120,
                    height: 16,
                    borderRadius: AppBorderRadius.xs,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AppShimmer(
                    width: 160,
                    height: 12,
                    borderRadius: AppBorderRadius.xs,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppShimmer(
                  width: 60,
                  height: 12,
                  borderRadius: AppBorderRadius.xs,
                ),
                SizedBox(height: AppSpacing.sm),
                AppShimmer(
                  width: 70,
                  height: 16,
                  borderRadius: AppBorderRadius.xs,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
