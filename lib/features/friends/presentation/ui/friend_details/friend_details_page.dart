import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/expenses/presentation/ui/widgets/expenses_list_view.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/presentation/blocs/friend_details/friend_details_bloc.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/group_balance_card.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'friend_details_form.dart';

class FriendDetailsPage
    extends BasePage<FriendDetailsBloc, FriendDetailsState> {
  const FriendDetailsPage({
    required this.friendId,
    this.friend,
    super.key,
  });

  final String friendId;
  final Friend? friend;

  @override
  FriendDetailsBloc createBloc() =>
      getIt<FriendDetailsBloc>()
        ..started(FriendDetailsParams(friendId: friendId, friend: friend));

  @override
  bool showLoading(FriendDetailsState state) =>
      state.store.loading && state.store.expenses.isEmpty;

  @override
  void handleStateChange(BuildContext context, FriendDetailsState state) {
    return switch (state) {
      OnFailure(:final failure) => AppSnackBar.show(
        context,
        message: failure.message,
      ),
      _ => () {},
    };
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<FriendDetailsBloc, FriendDetailsState>(
      builder: (context, state) {
        final currentFriend = state.store.friend ?? friend;
        final title = currentFriend?.name ?? context.strings.friendDetails;

        return Scaffold(
          appBar: AppTopBar(
            title: title,
          ),
          body: FriendDetailsForm(
            friendId: friendId,
            friend: currentFriend,
          ),
        );
      },
    );
  }
}
