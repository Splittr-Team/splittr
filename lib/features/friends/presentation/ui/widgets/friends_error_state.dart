import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
// TODO(Chaitanya): Use reusable error state

class FriendsErrorState extends StatelessWidget {
  const FriendsErrorState({
    required this.message,
    super.key,
  });

  final String message;

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
            AppText.titleMedium(
              message,
              color: context.colorScheme.error,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
