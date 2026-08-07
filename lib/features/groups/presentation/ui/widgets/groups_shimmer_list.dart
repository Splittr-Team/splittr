import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppSpacing;
import 'package:splittr/features/groups/presentation/ui/widgets/group_balance_card.dart';

class GroupsShimmerList extends StatelessWidget {
  const GroupsShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(
        height: AppSpacing.sm + AppSpacing.xs,
      ),
      itemBuilder: (context, index) => const GroupBalanceCardShimmer(),
    );
  }
}
