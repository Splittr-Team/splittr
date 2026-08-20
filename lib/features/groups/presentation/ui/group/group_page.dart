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
  bool showLoading(GroupState state) =>
      state.store.loading || state.store.group == null;

  @override
  void handleStateChange(BuildContext context, GroupState state) {
    return switch (state) {
      OnGroupDeleted _ => {
          AppSnackBar.show(
            context,
            message: context.strings.groupDeletedSuccessfully,
          ),
          RouteHandler.pop<void>(context),
        },
      OnGroupLeft _ => {
          AppSnackBar.show(
            context,
            message: context.strings.groupLeftSuccessfully,
          ),
          RouteHandler.pop<void>(context),
        },
      OnFailure(:final failure) => AppSnackBar.show(
          context,
          message: failure.message,
        ),
      _ => () {},
    };
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        final group = state.store.group;
        if (group == null) {
          return const SizedBox.shrink();
        }
        final isLoading = state.store.loading;

        return Scaffold(
          appBar: AppTopBar(
            title: group.name ?? context.strings.groupDetails,
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
            group: group,
            isLoading: isLoading,
          ),
        );
      },
    );
  }
}
