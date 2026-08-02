import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class ActivitiesEmptyState extends StatelessWidget {
  const ActivitiesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon.lg(
              Icons.history_rounded,
              color: context.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            AppText.titleLarge(
              context.strings.noRecentActivity,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText.bodyMedium(
              context.strings.noRecentActivitySubtitle,
              color: context.colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
