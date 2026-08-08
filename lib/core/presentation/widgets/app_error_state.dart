import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    required this.failure,
    this.icon = Icons.error_outline_rounded,
    this.retryLabel,
    this.onRetry,
    super.key,
  });

  final Failure failure;
  final IconData icon;
  final String? retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final children = [
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: context.colorScheme.errorContainer,
          borderRadius: .circular(AppRadius.lg),
        ),
        alignment: Alignment.center,
        child: AppIcon.lg(
          icon,
          color: context.colorScheme.error,
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      AppText.titleMedium(
        failure.message,
        color: context.colorScheme.error,
        textAlign: .center,
      ),
      if (onRetry != null) ...[
        const SizedBox(height: AppSpacing.lg),
        AppButton.secondary(
          text: retryLabel ?? context.strings.retry,
          onPressed: onRetry,
        ),
      ],
    ];

    return Center(
      child: AppScrollView(
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        children: children,
      ),
    );
  }
}
