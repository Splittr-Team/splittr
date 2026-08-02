import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class GroupsEmptyState extends StatelessWidget {
  const GroupsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSliverScrollView(
      slivers: [
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon.lg(
                    Icons.group_off_outlined,
                    color: context.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppText.titleLarge(
                    context.strings.noGroupsYet,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText.bodyMedium(
                    context.strings.createGroupEmptyStateSubtitle,
                    color: context.colorScheme.onSurfaceVariant,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
