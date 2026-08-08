import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/utils/extensions/extensions.dart';
// TODO(Chaitanya): Use reusable empty state

class FriendsEmptyState extends StatelessWidget {
  const FriendsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon.lg(
              Icons.people_outline_rounded,
              color: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppText.titleLarge(
              context.strings.noFriendsYet,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText.bodyMedium(
              context.strings.addFriendsEmptyStateSubtitle,
              color: context.colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
