import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group, State;
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
import 'package:splittr/features/groups/presentation/blocs/groups_bloc.dart'
    hide OnFailure;
import 'package:splittr/utils/extensions/extensions.dart';

class GroupSettingsPage extends StatelessWidget {
  const GroupSettingsPage({
    required this.groupId,
    super.key,
  });

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GroupBloc>()..started(groupId),
      child: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          switch (state) {
            case OnGroupDeleted _:
              _popAndShowSnackBar(
                context,
                context.strings.groupDeletedSuccessfully,
              );
            case OnGroupLeft _:
              _popAndShowSnackBar(
                context,
                context.strings.groupLeftSuccessfully,
              );
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
          builder: (context, groupState) {
            final currentGroup = groupState.store.group ?? Group(id: groupId);
            final isLoading =
                groupState.store.loading || groupState.store.group == null;

            return Scaffold(
              appBar: AppTopBar(
                title: context.strings.groupDetails,
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
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
                          onLeaveGroup: () => _confirmLeave(context),
                          onDeleteGroup: () => _confirmDelete(context),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black54,
                        child: Center(
                          child: AppProgressIndicator.circular(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showInviteLinkDialog(BuildContext context, String code) {
    final inviteLink = JoinGroupRoute(code).toDeepLink();

    unawaited(
      AppDialog.show<void>(
        context: context,
        title: context.strings.shareInviteLink,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText.bodyMedium(
              inviteLink,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          AppButton.text(
            onPressed: () => RouteHandler.pop<void>(context),
            text: context.strings.cancel,
          ),
          AppButton.primary(
            onPressed: () async {
              RouteHandler.pop<void>(context);
              await Clipboard.setData(ClipboardData(text: inviteLink));
              if (context.mounted) {
                AppSnackBar.show(
                  context,
                  message: context.strings.inviteLinkCopied,
                );
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
        title: context.strings.leaveGroup,
        description: context.strings.leaveGroupConfirmation,
        actions: [
          AppButton.text(
            onPressed: () => RouteHandler.pop<void>(context),
            text: context.strings.cancel,
          ),
          AppButton.text(
            onPressed: () {
              RouteHandler.pop<void>(context);
              final userId = context.read<AuthBloc>().state.user?.id;
              if (userId != null) {
                context.read<GroupBloc>().leaveGroup(userId);
              }
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
              RouteHandler.pop<void>(context);
              context.read<GroupBloc>().deleteGroup(groupId);
            },
            text: context.strings.delete,
            color: context.colorScheme.error,
          ),
        ],
      ),
    );
  }

  void _popAndShowSnackBar(BuildContext context, String message) {
    getIt<GroupsBloc>().started(noParams);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.headlineSmall(
                    group.name ?? context.strings.groupDetails,
                    color: context.colorScheme.onSurface,
                  ),
                  if (group.description != null &&
                      group.description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
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
    required this.onLeaveGroup,
    required this.onDeleteGroup,
  });

  final VoidCallback onLeaveGroup;
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
              ListTile(
                title: AppText.bodyLarge(
                  context.strings.leaveGroup,
                  color: context.colorScheme.error,
                ),
                leading: Icon(
                  Icons.exit_to_app_rounded,
                  color: context.colorScheme.error,
                ),
                onTap: onLeaveGroup,
              ),
              const Divider(height: 1),
              ListTile(
                title: AppText.bodyLarge(
                  context.strings.deleteGroup,
                  color: context.colorScheme.error,
                ),
                leading: Icon(
                  Icons.delete_forever_rounded,
                  color: context.colorScheme.error,
                ),
                onTap: onDeleteGroup,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
