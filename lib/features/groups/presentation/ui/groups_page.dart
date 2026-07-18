import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/groups/presentation/blocs/groups_bloc.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/create_group_bottom_sheet.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/group_actions_fab.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/groups_empty_state.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/groups_error_state.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/groups_list_view.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/groups_shimmer_list.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/join_group_bottom_sheet.dart';

part 'groups_form.dart';

class GroupsPage extends BasePage<GroupsBloc, GroupsState> {
  const GroupsPage({
    this.args,
    super.key,
  });
  final Map<String, dynamic>? args;

  @override
  GroupsBloc createBloc() => getIt<GroupsBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      floatingActionButton: GroupActionsFab(
        onCreateTapped: () => _showCreateGroupSheet(context),
        onJoinTapped: () => _showJoinGroupSheet(context),
      ),
      body: const _GroupsForm(),
    );
  }

  void _showCreateGroupSheet(BuildContext context) {
    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        child: const CreateGroupBottomSheet(),
      ),
    );
  }

  void _showJoinGroupSheet(BuildContext context) {
    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        child: const JoinGroupBottomSheet(),
      ),
    );
  }
}
