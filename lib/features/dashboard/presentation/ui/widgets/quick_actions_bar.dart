import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/create_group_bottom_sheet.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class QuickActionsBar extends StatelessWidget {
  const QuickActionsBar({super.key});

  void _openCreateGroupSheet(BuildContext context) {
    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        title: context.strings.createGroup,
        child: const CreateGroupBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add_rounded,
            label: 'Add Expense',
            iconBgColor: context.colorScheme.primaryContainer,
            iconColor: context.colorScheme.onPrimaryContainer,
            onTap: () => const AddExpenseRoute().push<void>(context),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.handshake_rounded,
            label: context.strings.settleUp,
            iconBgColor: context.colorScheme.secondaryContainer,
            iconColor: context.colorScheme.onSecondaryContainer,
            onTap: () => const SettleUpRoute().push<void>(context),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.group_add_rounded,
            label: 'New Group',
            iconBgColor: context.colorScheme.tertiaryContainer,
            iconColor: context.colorScheme.onTertiaryContainer,
            onTap: () => _openCreateGroupSheet(context),
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard.outlined(
      color: context.colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: iconBgColor,
                foregroundColor: iconColor,
                child: AppIcon.md(icon),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText.labelMedium(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
