import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/app_config/domain/stores/app_config_store.dart';

class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt<AppConfigStore>();
    final message = store.updateMessage;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.system_update, size: 80, color: Colors.blue),
            const SizedBox(height: AppSpacing.lg),
            const AppText.headlineMedium(
              'Update Required',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppText.bodyMedium(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
    );
  }
}
