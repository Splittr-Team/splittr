import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/presentation/blocs/group/group_bloc.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'group_form.dart';

enum GroupActionOption { addMembers, shareInvite, leave, delete }

class GroupPage extends BasePage<GroupBloc, GroupState> {
  const GroupPage({
    required this.groupId,
    super.key,
  });

  final String groupId;

  @override
  GroupBloc createBloc() => getIt<GroupBloc>()..started(groupId);

  @override
  bool showLoading(GroupState state) => state.store.loading;

  @override
  Widget buildPage(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        switch (state) {
          case OnGroupDeleted():
            AppSnackBar.show(
              context,
              message: context.strings.groupDeletedSuccessfully,
            );
            RouteHandler.pop<void>(context);
          case OnGroupLeft():
            AppSnackBar.show(
              context,
              message: context.strings.groupLeftSuccessfully,
            );
            RouteHandler.pop<void>(context);
          case OnFailure(:final failure):
            AppSnackBar.show(context, message: failure.message);
          case _:
            break;
        }
      },
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          final isLoading = state.store.loading;

          return Scaffold(
            appBar: AppTopBar(
              title: state.store.group?.name ?? context.strings.groupDetails,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: AppIconButton(
                    icon: Icons.settings_outlined,
                    onPressed: () {
                      unawaited(
                        GroupSettingsRoute(
                          groupId: groupId,
                        ).push<void>(context),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: _GroupForm(
              groupId: groupId,
              group: state.store.group,
              isLoading: isLoading,
            ),
          );
        },
      ),
    );
  }
}
