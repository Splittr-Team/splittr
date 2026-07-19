import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart'
    show
        AppButton,
        AppIcon,
        AppSpacing,
        AppText,
        SkyDesignSystemContextExtension;
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({
    required this.errorMessage,
    super.key,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const .all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon.lg(
                Icons.error_outline_rounded,
                color: context.colorScheme.error,
              ),
              const SizedBox(height: 24),
              AppText.titleLarge(context.strings.navigationError),
              const SizedBox(height: 12),
              AppText.bodyMedium(
                errorMessage,
                textAlign: TextAlign.center,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 32),
              AppButton.primary(
                onPressed: () => const DashboardRoute().go(context),
                text: context.strings.backToDashboard,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
