import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class ActivitiesErrorState extends StatelessWidget {
  const ActivitiesErrorState({
    required this.message,
    this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon.lg(
              Icons.error_outline_rounded,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            AppText.titleLarge(
              context.strings.failedToLoadActivities,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText.bodyMedium(
              message,
              color: context.colorScheme.error,
              textAlign: TextAlign.center,
            ),
            if (onRetry case final callback?) ...[
              const SizedBox(height: AppSpacing.md),
              AppButton.secondary(
                text: context.strings.retry,
                onPressed: callback,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
