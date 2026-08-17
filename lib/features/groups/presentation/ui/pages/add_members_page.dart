import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart' hide State;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/friends/presentation/blocs/friends_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/friends/presentation/ui/widgets/friend_card.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friends_shimmer_list.dart';
import 'package:splittr/features/groups/presentation/blocs/group/group_bloc.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class AddMembersPage extends StatelessWidget {
  const AddMembersPage({required this.groupId, super.key});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    var searchQuery = '';
    final selectedFriendIds = <String>{};

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<GroupBloc>()..started(groupId),
        ),
        BlocProvider(
          create: (context) => getIt<FriendsBloc>()..started(noParams),
        ),
      ],
      child: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          switch (state) {
            case OnMembersAdded _:
              AppSnackBar.show(
                context,
                message: context.strings.invitesSentSuccessfully,
              );
              RouteHandler.pop<void>(context);
            case OnFailure(:final failure):
              AppSnackBar.show(
                context,
                message: failure.message,
              );
            case _:
              break;
          }
        },
        child: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, detailsState) {
            final isLoading = detailsState.store.loading;

            return StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(context.strings.addMembers),
                  ),
                  body: BlocBuilder<FriendsBloc, FriendsState>(
                    builder: (context, friendsState) {
                      final isLoadingFriends =
                          friendsState.store.loading &&
                          friendsState.store.friends.isEmpty;

                      if (isLoadingFriends) {
                        return const FriendsShimmerList();
                      }

                      final friends = friendsState.store.friends;
                      final filteredFriends = friends.where((friend) {
                        final query = searchQuery.toLowerCase();
                        final name = (friend.name ?? '').toLowerCase();
                        final email = (friend.email ?? '').toLowerCase();
                        final phone = (friend.phone ?? '').toLowerCase();
                        return name.contains(query) ||
                            email.contains(query) ||
                            phone.contains(query);
                      }).toList();

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: AppTextField(
                              labelText: context.strings.emailOrPhone,
                              hintText: context.strings.enterEmailOrPhone,
                              onChanged: (val) {
                                setState(() {
                                  searchQuery = val;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: filteredFriends.isEmpty
                                ? Center(
                                    child: AppText.bodyMedium(
                                      context.strings.noFriendsFound,
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                    ),
                                    itemCount: filteredFriends.length,
                                    itemBuilder: (context, index) {
                                      final friend = filteredFriends[index];
                                      final friendId = friend.id ?? '';
                                      final isSelected = selectedFriendIds
                                          .contains(friendId);

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppSpacing.sm,
                                        ),
                                        child: FriendCard(
                                          name: friend.name ?? '',
                                          email: friend.email ?? '',
                                          phone: friend.phone,
                                          onTap: isLoading
                                              ? null
                                              : () {
                                                  setState(() {
                                                    if (isSelected) {
                                                      selectedFriendIds.remove(
                                                        friendId,
                                                      );
                                                    } else {
                                                      selectedFriendIds.add(
                                                        friendId,
                                                      );
                                                    }
                                                  });
                                                },
                                          trailing: Checkbox(
                                            value: isSelected,
                                            activeColor:
                                                context.colorScheme.primary,
                                            onChanged: isLoading
                                                ? null
                                                : (val) {
                                                    setState(() {
                                                      if (val == true) {
                                                        selectedFriendIds.add(
                                                          friendId,
                                                        );
                                                      } else {
                                                        selectedFriendIds
                                                            .remove(friendId);
                                                      }
                                                    });
                                                  },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                  bottomNavigationBar: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        border: Border(
                          top: BorderSide(
                            color: context.colorScheme.outlineVariant,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: isLoading
                          ? ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colorScheme.primary,
                              ),
                              child: const SizedBox(
                                height: 20,
                                width: 20,
                                child: AppProgressIndicator.circular(),
                              ),
                            )
                          : AppButton.primary(
                              text: context.strings.sendInvites,
                              onPressed: selectedFriendIds.isNotEmpty
                                  ? () {
                                      getBloc<GroupBloc>(context).addMembers(
                                        userIds: selectedFriendIds.toList(),
                                      );
                                    }
                                  : null,
                            ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
