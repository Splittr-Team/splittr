import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppSpacing;
import 'package:splittr/core/presentation/widgets/paginated_list_view.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/presentation/blocs/groups_bloc.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/group_balance_card.dart';

class GroupsListView extends StatelessWidget {
  const GroupsListView({
    required this.groups,
    required this.hasMore,
    required this.isLoadingMore,
    super.key,
  });

  final List<Group> groups;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    final groupIcons = [
      Icons.umbrella_rounded,
      Icons.home_rounded,
      Icons.coffee_rounded,
      Icons.restaurant_rounded,
      Icons.directions_car_rounded,
    ];

    return PaginatedListView<Group>(
      items: groups,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      onLoadMore: () => context.read<GroupsBloc>().fetchNextPage(),
      padding: const EdgeInsets.all(AppSpacing.md),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, group, index) {
        final icon = groupIcons[index % groupIcons.length];
        final balanceState =
            BalanceState.values[index % BalanceState.values.length];

        return GroupBalanceCard(
          key: ValueKey(group),
          title: group.name!,
          subtitle: group.description!,
          icon: icon,
          balanceState: balanceState,
          amountText: '1000',
          onTap: () async {
            await GroupDetailsRoute(
              groupId: group.id ?? '',
              group: group,
            ).push<void>(context);
          },
        );
      },
    );
  }
}
