import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/app_config/domain/stores/app_config_store.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt<AppConfigStore>();
    final message = store.maintenanceMessage;
    final estimatedEndTime = store.config?.system.maintenance.estimatedEndTime;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.build_circle, size: 80, color: Colors.amber),
            const SizedBox(height: AppSpacing.lg),
            const AppText.headlineMedium(
              'Under Maintenance',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppText.bodyMedium(message, textAlign: TextAlign.center),
            if (estimatedEndTime != null) ...[
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              AppText.bodySmall(
                'Estimated completion: $estimatedEndTime',
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
