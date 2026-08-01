import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';

class ActivityItemCard extends StatelessWidget {
  const ActivityItemCard({
    required this.activity,
    super.key,
  });

  final Activity activity;

  IconData _getIconForAction(String actionType) {
    return switch (actionType) {
      'expense_created' || 'expenseCreated' => Icons.receipt_long_rounded,
      'settlement' => Icons.handshake_rounded,
      'member_added' ||
      'memberAdded' ||
      'member_joined' ||
      'memberJoined' => Icons.person_add_rounded,
      'group_created' || 'groupCreated' => Icons.group_add_rounded,
      _ => Icons.notifications_active_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd().add_jm();
    final formattedDate = dateFormat.format(activity.createdAt);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: AppIcon.md(
              _getIconForAction(activity.actionType),
              color: context.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bodyMedium(
                  activity.description,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText.labelSmall(
                  formattedDate,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
