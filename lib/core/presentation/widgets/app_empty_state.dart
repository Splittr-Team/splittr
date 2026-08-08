import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final children = [
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHigh,
          borderRadius: .circular(AppRadius.lg),
        ),
        alignment: Alignment.center,
        child: AppIcon.lg(
          icon,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      AppText.titleLarge(
        title,
        textAlign: .center,
      ),
      if (subtitle case final subtitle?) ...[
        const SizedBox(height: AppSpacing.xs),
        AppText.bodyMedium(
          subtitle,
          color: context.colorScheme.onSurfaceVariant,
          textAlign: .center,
        ),
      ],
      if ((actionLabel, onAction) case (
        final actionLabel?,
        final onAction?,
      )) ...[
        const SizedBox(height: AppSpacing.lg),
        AppButton.secondary(
          text: actionLabel,
          onPressed: onAction,
        ),
      ],
    ];

    return Center(
      child: AppScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        children: children,
      ),
    );
  }
}
