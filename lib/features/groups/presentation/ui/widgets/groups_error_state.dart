import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';

class GroupsErrorState extends StatelessWidget {
  const GroupsErrorState({
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
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: TextStyle(
                color: context.colorScheme.error,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
