import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';

/// Shimmer skeleton loader displayed while notifications are loading.
class NotificationsShimmerLoader extends StatelessWidget {
  const NotificationsShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 6,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(
          children: [
            AppShimmer.circle(size: 40),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer(
                    height: 16,
                    width: 140,
                    borderRadius: AppBorderRadius.xs,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  AppShimmer(
                    height: 12,
                    width: double.infinity,
                    borderRadius: AppBorderRadius.xs,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
