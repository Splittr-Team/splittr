import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppSpacing;
import 'package:splittr/core/presentation/widgets/paginated_list_view.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/friends/presentation/blocs/friends_bloc.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friend_card.dart';

class FriendsListView extends StatelessWidget {
  const FriendsListView({
    required this.friends,
    required this.hasMore,
    required this.isLoadingMore,
    super.key,
  });

  final List<User> friends;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return PaginatedListView<User>(
      items: friends,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      onLoadMore: () => context.read<FriendsBloc>().fetchNextPage(),
      padding: const EdgeInsets.all(AppSpacing.md),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, friend, index) {
        return FriendCard(
          key: ValueKey(friend.id ?? friend.email ?? index.toString()),
          name: friend.name ?? '',
          email: friend.email ?? '',
          phone: friend.phone,
          onTap: () {
            // Future tap handling if needed
          },
        );
      },
    );
  }
}
