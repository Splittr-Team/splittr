import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/presentation/widgets/widgets.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/friends/presentation/blocs/friends_bloc.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/add_friend_bottom_sheet.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friends_list_view.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friends_shimmer_list.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'friends_form.dart';

class FriendsPage extends BasePage<FriendsBloc, FriendsState> {
  const FriendsPage({super.key});

  @override
  FriendsBloc createBloc() => getIt<FriendsBloc>()..started(noParams);

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppButton.fab(
        onPressed: () => _showAddFriendSheet(context),
        icon: Icons.person_add_rounded,
      ),
      body: const _FriendsForm(),
    );
  }

  void _showAddFriendSheet(BuildContext context) {
    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        title: context.strings.addFriend,
        child: const AddFriendBottomSheet(),
      ),
    );
  }
}
