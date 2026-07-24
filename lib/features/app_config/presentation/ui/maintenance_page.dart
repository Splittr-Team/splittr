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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.build_circle, size: 80, color: Colors.amber),
            const SizedBox(height: 24),
            const AppText.headlineMedium(
              'Under Maintenance',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppText.bodyMedium(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
