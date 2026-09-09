import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/features/expenses/domain/entities/balances.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({
    this.balances,
    this.currency = 'INR',
    super.key,
  });

  final Balances? balances;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final isDark = context.colorScheme.brightness == Brightness.dark;
    final greenColor = isDark
        ? Colors.greenAccent.shade400
        : Colors.green.shade700;
    final redColor = context.colorScheme.error;

    num totalOwed = 0;
    num totalOwe = 0;

    final userBalances = balances?.balances ?? [];
    for (final b in userBalances) {
      if (b.netBalance > 0) {
        totalOwed += b.netBalance;
      } else if (b.netBalance < 0) {
        totalOwe += b.netBalance.abs();
      }
    }

    final netBalance = totalOwed - totalOwe;
    final netBalancePrefix = netBalance > 0
        ? '+'
        : netBalance < 0
        ? '-'
        : '';
    final netColor = netBalance > 0
        ? greenColor
        : netBalance < 0
        ? redColor
        : context.colorScheme.onSurface;

    final formattedAmount =
        '$netBalancePrefix$currency ${netBalance.abs().toStringAsFixed(2)}';

    return AppCard.outlined(
      color: context.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText.labelMedium(
              'TOTAL BALANCE',
              color: context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText.headlineLarge(
              formattedAmount,
              color: netColor,
            ),
            const SizedBox(height: AppSpacing.md),
            const AppDivider.horizontal(),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_downward_rounded,
                            size: 16,
                            color: greenColor,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          AppText.labelMedium(
                            context.strings.youAreOwed,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText.titleMedium(
                        '+$currency ${totalOwed.toStringAsFixed(2)}',
                        color: greenColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: context.colorScheme.outlineVariant,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_upward_rounded,
                            size: 16,
                            color: redColor,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          AppText.labelMedium(
                            context.strings.youOwe,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText.titleMedium(
                        '-$currency ${totalOwe.toStringAsFixed(2)}',
                        color: redColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
