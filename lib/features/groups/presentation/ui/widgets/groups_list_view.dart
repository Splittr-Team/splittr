import 'package:flutter/material.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/route_paths.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/group_balance_card.dart';

class GroupsListView extends StatelessWidget {
  const GroupsListView({
    required this.groups,
    super.key,
  });

  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    final groupIcons = [
      Icons.umbrella_rounded,
      Icons.home_rounded,
      Icons.coffee_rounded,
      Icons.restaurant_rounded,
      Icons.directions_car_rounded,
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final group = groups[index];
        final icon = groupIcons[index % groupIcons.length];
        final balanceState =
            BalanceState.values[index % BalanceState.values.length];

        return GroupBalanceCard(
          title: group.name!,
          subtitle: group.description!,
          icon: icon,
          balanceState: balanceState,
          amountText: '1000',
          onTap: () async {
            await RouteHandler.push<void>(
              context,
              RoutePaths.groupDetails,
              extra: {'group': group},
            );
          },
        );
      },
    );
  }
}
