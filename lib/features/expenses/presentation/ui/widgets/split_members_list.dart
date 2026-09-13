import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/features/expenses/domain/entities/input_split.dart';
import 'package:splittr/features/expenses/domain/entities/split_type.dart';
import 'package:splittr/features/expenses/presentation/ui/widgets/payer_selector_bottom_sheet.dart';

class SplitMembersList extends StatelessWidget {
  const SplitMembersList({
    required this.members,
    required this.splitType,
    required this.splits,
    required this.totalAmount,
    required this.currency,
    required this.onParticipantToggled,
    required this.onSplitAmountChanged,
    required this.onSplitPercentageChanged,
    super.key,
  });

  final List<PayerItem> members;
  final SplitType splitType;
  final List<InputSplit> splits;
  final num totalAmount;
  final String currency;
  final ValueChanged<String> onParticipantToggled;
  final void Function(String userId, num amount) onSplitAmountChanged;
  final void Function(String userId, num percentage) onSplitPercentageChanged;

  @override
  Widget build(BuildContext context) {
    final splitMap = {for (final s in splits) s.userId: s};
    final activeCount = splits.length;
    final equalShare = activeCount > 0 ? (totalAmount / activeCount) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.titleSmall(
          'Split with (${splits.length}/${members.length})',
          color: context.colorScheme.onSurface,
        ),
        const SizedBox(height: AppSpacing.sm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, index) {
            final member = members[index];
            final currentSplit = splitMap[member.id];
            final isIncluded = currentSplit != null;

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isIncluded
                    ? context.colorScheme.surfaceContainer
                    : context.colorScheme.surfaceContainerLow,
                borderRadius: AppBorderRadius.md,
                border: Border.all(
                  color: isIncluded
                      ? context.colorScheme.outlineVariant
                      : context.colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                ),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: isIncluded,
                    onChanged: (_) => onParticipantToggled(member.id),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.bodyMedium(
                          member.name,
                          color: context.colorScheme.onSurface,
                        ),
                        if (member.email != null)
                          AppText.bodySmall(
                            member.email!,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (isIncluded) ...[
                    switch (splitType) {
                      SplitType.equal => AppText.titleSmall(
                        '$currency ${equalShare.toStringAsFixed(2)}',
                        color: context.colorScheme.primary,
                      ),
                      SplitType.exact => SizedBox(
                        width: 90,
                        child: AppTextField(
                          initialValue: currentSplit is ExactInputSplit
                              ? currentSplit.amount.toString()
                              : '0',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              left: AppSpacing.xs,
                              top: AppSpacing.xs,
                            ),
                            child: AppText.labelSmall(currency),
                          ),
                          onChanged: (val) {
                            final parsed = num.tryParse(val) ?? 0;
                            onSplitAmountChanged(member.id, parsed);
                          },
                        ),
                      ),
                      SplitType.percentage => SizedBox(
                        width: 80,
                        child: AppTextField(
                          initialValue: currentSplit is PercentageInputSplit
                              ? currentSplit.percentage.toString()
                              : '0',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only(
                              right: AppSpacing.xs,
                              top: AppSpacing.xs,
                            ),
                            child: AppText.labelSmall('%'),
                          ),
                          onChanged: (val) {
                            final parsed = num.tryParse(val) ?? 0;
                            onSplitPercentageChanged(member.id, parsed);
                          },
                        ),
                      ),
                    },
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
