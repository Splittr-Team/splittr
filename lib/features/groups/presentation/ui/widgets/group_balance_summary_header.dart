import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/features/expenses/presentation/blocs/expenses/expenses_bloc.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/group_balance_card.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class GroupBalanceSummaryHeader extends StatelessWidget {
  const GroupBalanceSummaryHeader({
    required this.groupId,
    required this.group,
    super.key,
  });

  final String groupId;
  final Group group;

  @override
  Widget build(BuildContext context) {
    final currentUserId = getBloc<AuthBloc>(context).state.user?.id;

    return BlocBuilder<ExpensesBloc, ExpensesState>(
      builder: (context, state) {
        final balances = state.store.balances;
        final userBalance = balances?.balances
            .where(
              (b) => b.userId == currentUserId,
            )
            .firstOrNull;

        final netBalance = userBalance?.netBalance ?? 0;
        final currency =
            userBalance?.currency ??
            balances?.directSettlements.firstOrNull?.currency ??
            balances?.simplifiedSettlements.firstOrNull?.currency ??
            r'$';

        final BalanceState balanceState;
        if (netBalance > 0.001) {
          balanceState = BalanceState.owed;
        } else if (netBalance < -0.001) {
          balanceState = BalanceState.owes;
        } else {
          balanceState = BalanceState.settled;
        }

        final isDark = context.colorScheme.brightness == Brightness.dark;
        Color statusColor;
        String statusText;

        switch (balanceState) {
          case BalanceState.owed:
            statusColor = isDark
                ? Colors.greenAccent.shade400
                : Colors.green.shade700;
            statusText = context.strings.youAreOwed;
          case BalanceState.owes:
            statusColor = context.colorScheme.error;
            statusText = context.strings.youOwe;
          case BalanceState.settled:
            statusColor = context.colorScheme.onSurfaceVariant.withValues(
              alpha: 0.7,
            );
            statusText = context.strings.allSettledUp;
        }

        final amountText = '$currency${netBalance.abs().toStringAsFixed(2)}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Group info card
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: AppCard.outlined(
                color: context.colorScheme.surfaceContainerHigh,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: context.colorScheme.primaryContainer,
                        foregroundColor: context.colorScheme.onPrimaryContainer,
                        child: const AppIcon.lg(Icons.group_rounded),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.titleLarge(
                              group.name ?? context.strings.groupDetails,
                              color: context.colorScheme.onSurface,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            AppText.bodyMedium(
                              context.strings.membersCount(
                                group.members.length,
                              ),
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Net balance summary card
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: AppCard.outlined(
                color: context.colorScheme.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: statusColor.withValues(alpha: 0.12),
                        foregroundColor: statusColor,
                        child: Icon(
                          balanceState == BalanceState.settled
                              ? Icons.check_circle_outline_rounded
                              : (balanceState == BalanceState.owed
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.labelMedium(
                              statusText,
                              color: statusColor,
                            ),
                            if (balanceState != BalanceState.settled) ...[
                              const SizedBox(height: AppSpacing.xs),
                              AppText.titleMedium(
                                amountText,
                                color: statusColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                      AppButton.text(
                        text: context.strings.settleUp,
                        icon: Icons.handshake_outlined,
                        onPressed: () {
                          unawaited(
                            SettleUpRoute(
                              args: SettleUpArgs(groupId: groupId),
                            ).push<void>(context),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
