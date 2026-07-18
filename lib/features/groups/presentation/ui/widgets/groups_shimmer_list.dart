import 'package:flutter/material.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/group_balance_card.dart';

class GroupsShimmerList extends StatelessWidget {
  const GroupsShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const GroupBalanceCardShimmer(),
    );
  }
}
