import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';

class ActivitiesShimmerList extends StatelessWidget {
  const ActivitiesShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 8,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return const AppShimmer(
          child: Card(
            child: SizedBox(
              height: 72,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }
}
