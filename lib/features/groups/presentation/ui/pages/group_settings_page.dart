import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';
import 'package:splittr/features/groups/presentation/blocs/group/group_bloc.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class GroupSettingsPage extends BasePage<GroupBloc, GroupState> {
  const GroupSettingsPage({
    required this.groupId,
    super.key,
  });

  final String groupId;

  @override
  GroupBloc createBloc() =>
      getIt<GroupBloc>()..started(GroupParams(groupId: groupId));

  @override
  bool showLoading(GroupState state) =>
      state.store.loading || state.store.group == null;

  void handleState(BuildContext context, GroupState state) {
    return switch (state) {
      OnGroupDeleted _ => _popAndShowSnackBar(
        context,
        context.strings.groupDeletedSuccessfully,
      ),
      OnGroupLeft _ => _popAndShowSnackBar(
        context,
        context.strings.groupLeftSuccessfully,
      ),
      OnFailure(:final failure) => AppSnackBar.show(
        context,
        message: failure.message,
      ),
      _ => () {},
    };
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: handleState,
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, groupState) {
          final currentGroup = groupState.store.group;
          if (currentGroup == null) {
            return const SizedBox.shrink();
          }

          return Scaffold(
            appBar: AppTopBar(
              title: context.strings.groupDetails,
            ),
            body: AppScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _GroupEditSection(group: currentGroup),
                    const SizedBox(height: AppSpacing.md),
                    _MemberSection(
                      members: currentGroup.members,
                      onAddMembers: () {
                        unawaited(
                          AddMembersRoute(
                            groupId: groupId,
                          ).push<void>(context),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (currentGroup.inviteCode != null) ...[
                      _InviteCodeCard(
                        inviteCode: currentGroup.inviteCode!,
                        onShare: () => _showInviteLinkDialog(
                          context,
                          currentGroup.inviteCode!,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    _DangerZone(
                      onLeaveOrRemoveGroup: () => _confirmLeave(context),
                      onDeleteGroup: () => _confirmDelete(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showInviteLinkDialog(BuildContext context, String code) {
    final inviteLink = JoinGroupRoute(code).toDeepLink();

    unawaited(
      AppDialog.show<void>(
        context: context,
        title: context.strings.shareInviteLink,
        description: inviteLink,
        actions: [
          AppButton.text(
            onPressed: () => RouteHandler.pop<void>(context),
            text: context.strings.cancel,
          ),
          AppButton.primary(
            onPressed: () async {
              // TODO(Chaitanya): Move to Utils
              await Clipboard.setData(ClipboardData(text: inviteLink));
              if (context.mounted) {
                AppSnackBar.show(
                  context,
                  message: context.strings.inviteLinkCopied,
                );
                RouteHandler.pop<void>(context);
              }
            },
            text: context.strings.copyLink,
          ),
        ],
      ),
    );
  }

  void _confirmLeave(BuildContext context) {
    unawaited(
      AppDialog.show<void>(
        context: context,
        title: context.strings.leaveOrRemoveGroup,
        description: context.strings.leaveOrRemoveGroupConfirmation,
        actions: [
          AppButton.text(
            onPressed: () => RouteHandler.pop<void>(context),
            text: context.strings.cancel,
          ),
          AppButton.text(
            onPressed: () {
              final userId = getBloc<AuthBloc>(context).state.user?.id;
              if (userId != null) {
                getBloc<GroupBloc>(context).leaveOrRemoveGroup(userId: userId);
              }
              RouteHandler.pop<void>(context);
            },
            text: context.strings.confirm,
            color: context.colorScheme.error,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    unawaited(
      AppDialog.show<void>(
        context: context,
        title: context.strings.deleteGroup,
        description: context.strings.deleteGroupConfirmation,
        actions: [
          AppButton.text(
            onPressed: () => RouteHandler.pop<void>(context),
            text: context.strings.cancel,
          ),
          AppButton.text(
            onPressed: () {
              getBloc<GroupBloc>(context).deleteGroup(groupId: groupId);
              RouteHandler.pop<void>(context);
            },
            text: context.strings.delete,
            color: context.colorScheme.error,
          ),
        ],
      ),
    );
  }

  void _popAndShowSnackBar(BuildContext context, String message) {
    AppSnackBar.show(context, message: message);
    RouteHandler.pushAndRemoveUntil(context, GroupsRoute.pathTemplate);
  }
}

// TODO(Chaitanya): Integrate API for editing
class _GroupEditSection extends StatelessWidget {
  const _GroupEditSection({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return AppCard.outlined(
      color: context.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // TODO(Chaitanya): Will remove it later
            CircleAvatar(
              radius: 28,
              backgroundColor: context.colorScheme.primaryContainer,
              child: Icon(
                Icons.group_rounded,
                color: context.colorScheme.onPrimaryContainer,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                spacing: AppSpacing.xs,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.headlineSmall(
                    group.name ?? context.strings.groupDetails,
                    color: context.colorScheme.onSurface,
                  ),
                  if (group.description != null &&
                      group.description!.isNotEmpty) ...[
                    AppText.bodyMedium(
                      group.description!,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
            AppIconButton(
              icon: Icons.edit_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _InviteCodeCard extends StatelessWidget {
  const _InviteCodeCard({
    required this.inviteCode,
    required this.onShare,
  });

  final String inviteCode;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return AppCard.outlined(
      color: context.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.labelMedium(
                    context.strings.inviteCode.toUpperCase(),
                    color: context.colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText.titleLarge(
                    inviteCode,
                    color: context.colorScheme.onSurface,
                  ),
                ],
              ),
            ),
            AppIconButton.outlined(
              icon: Icons.share_rounded,
              onPressed: onShare,
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberSection extends StatelessWidget {
  const _MemberSection({
    required this.members,
    required this.onAddMembers,
  });

  final List<Member> members;
  final VoidCallback onAddMembers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.labelLarge(
              context.strings.membersCount(members.length).toUpperCase(),
              color: context.colorScheme.primary,
            ),
            AppButton.text(
              text: context.strings.addMembers,
              icon: Icons.add_rounded,
              onPressed: onAddMembers,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (members.isEmpty)
          AppCard.outlined(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Center(
                child: AppText.bodyMedium(
                  context.strings.noMembersFound,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            // TODO(Chaitanya): Dont use shrinkwrap
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: AppSpacing.sm,
            ),
            itemBuilder: (context, index) {
              final member = members[index];
              return _MemberTile(member: member);
            },
          ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    final name = member.name ?? member.email ?? member.phone ?? '';
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
        : null;

    final roleText = member.role?.name ?? '';

    return AppCard.outlined(
      color: context.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            AppAvatar(
              initials: initials,
              backgroundImage: initials == null
                  ? const NetworkImage(
                      'https://www.gravatar.com/avatar/'
                      '00000000000000000000000000000000?d=mp&f=y',
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.titleMedium(
                    name,
                    color: context.colorScheme.onSurface,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (member.email != null && member.email!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    AppText.bodyMedium(
                      member.email!,
                      color: context.colorScheme.onSurfaceVariant,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (member.phone != null && member.phone!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    AppText.bodyMedium(
                      member.phone!,
                      color: context.colorScheme.onSurfaceVariant,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (roleText.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: member.role == Role.admin
                      ? context.colorScheme.primaryContainer
                      : context.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText.labelSmall(
                  roleText,
                  color: member.role == Role.admin
                      ? context.colorScheme.onPrimaryContainer
                      : context.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DangerZone extends StatelessWidget {
  const _DangerZone({
    required this.onLeaveOrRemoveGroup,
    required this.onDeleteGroup,
  });

  final VoidCallback onLeaveOrRemoveGroup;
  final VoidCallback onDeleteGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.labelLarge(
          context.strings.dangerZone,
          color: context.colorScheme.error,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard.outlined(
          color: context.colorScheme.errorContainer.withValues(alpha: 0.05),
          child: Column(
            children: [
              AppListTile(
                title: context.strings.leaveOrRemoveGroup,
                leadingIcon: Icons.exit_to_app_rounded,
                onTap: onLeaveOrRemoveGroup,
              ),
              const AppDivider.horizontal(),
              AppListTile(
                title: context.strings.deleteGroup,
                leadingIcon: Icons.delete_forever_rounded,
                onTap: onDeleteGroup,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
