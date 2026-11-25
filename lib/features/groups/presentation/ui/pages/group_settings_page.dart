import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/presentation/widgets/widgets.dart';
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
      OnGroupIconUpdated _ => AppSnackBar.show(
        context,
        message: context.strings.groupIconUpdatedSuccessfully,
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

          return AppScaffold(
            backgroundColor: context.colorScheme.surfaceContainerLowest,
            appBar: AppTopBar(
              title: context.strings.groupDetails,
            ),
            body: AppScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              children: [
                _GroupHeader(group: currentGroup),
                const SizedBox(height: AppSpacing.xl),
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
                if (currentGroup.inviteCode != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  _InviteCodeSection(
                    inviteCode: currentGroup.inviteCode!,
                    onShare: () => _showInviteLinkDialog(
                      context,
                      currentGroup.inviteCode!,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                _DangerZone(
                  onLeaveOrRemoveGroup: () => _confirmLeave(context),
                  onDeleteGroup: () => _confirmDelete(context),
                ),
                const SizedBox(height: AppSpacing.xxl),
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

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return MediaPickerWidget(
      maxSizeBytes: 2 * 1024 * 1024,
      sheetTitle: context.strings.changeGroupIcon,
      onImagePicked: (file) {
        getBloc<GroupBloc>(context).uploadGroupIcon(file: file);
      },
      builder: (context, showPicker) {
        return Column(
          children: [
            _EditableAvatar(
              imageUrl: group.iconUrl,
              onTap: showPicker,
            ),
            const SizedBox(height: AppSpacing.md),
            AppText.headlineSmall(
              group.name ?? context.strings.groupDetails,
              color: context.colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
            if (group.description != null && group.description!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              AppText.bodyMedium(
                group.description!,
                color: context.colorScheme.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _EditableAvatar extends StatelessWidget {
  const _EditableAvatar({
    required this.onTap,
    this.imageUrl,
  });

  static const double _radius = AppRadius.xxl;
  static const double _diameter = _radius * 2;

  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final imageProvider = switch (imageUrl) {
      final url? when url.isNotEmpty => NetworkImage(url),
      _ => null,
    };

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: _diameter,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: AppAvatar.icon(
                icon: Icons.group_rounded,
                radius: _radius,
                backgroundImage: imageProvider,
                onBackgroundImageError: imageProvider != null
                    ? (_, _) {}
                    : null,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colorScheme.surfaceContainerLowest,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.add_a_photo,
                  size: 14,
                  color: context.colorScheme.onPrimary,
                ),
              ),
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
            AppText.titleMedium(
              context.strings.membersCount(members.length),
              color: context.colorScheme.onSurface,
            ),
            AppButton.text(
              text: context.strings.addMembers,
              icon: Icons.add_rounded,
              onPressed: onAddMembers,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Material(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: members.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Center(
                    child: AppText.bodyMedium(
                      context.strings.noMembersFound,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < members.length; i++) ...[
                      if (i > 0) const AppDivider.horizontal(),
                      _MemberTile(member: members[i]),
                    ],
                  ],
                ),
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

    return AppListTile(
      title: name,
      subtitle: member.email?.isNotEmpty == true
          ? member.email
          : (member.phone?.isNotEmpty == true ? member.phone : null),
      leadingWidget: initials != null
          ? AppAvatar.initials(
              radius: AppRadius.md,
              initials: initials,
            )
          : const AppAvatar.icon(
              icon: Icons.person,
              radius: AppRadius.md,
              backgroundImage: NetworkImage(
                'https://www.gravatar.com/avatar/'
                '00000000000000000000000000000000?d=mp&f=y',
              ),
            ),
      trailingWidget: roleText.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: member.role == Role.admin
                    ? context.colorScheme.primaryContainer
                    : context.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: AppText.labelSmall(
                roleText,
                color: member.role == Role.admin
                    ? context.colorScheme.onPrimaryContainer
                    : context.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
    );
  }
}

class _InviteCodeSection extends StatelessWidget {
  const _InviteCodeSection({
    required this.inviteCode,
    required this.onShare,
  });

  final String inviteCode;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.titleMedium(
          context.strings.inviteCode,
          color: context.colorScheme.onSurface,
        ),
        const SizedBox(height: AppSpacing.sm),
        Material(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: AppListTile(
            leadingIcon: Icons.share_rounded,
            title: context.strings.shareInviteLink,
            subtitle: inviteCode,
            trailingWidget: AppIconButton(
              icon: Icons.copy_rounded,
              onPressed: () async {
                unawaited(Clipboard.setData(ClipboardData(text: inviteCode)));
                if (context.mounted) {
                  AppSnackBar.show(
                    context,
                    message: context.strings.inviteLinkCopied,
                  );
                }
              },
            ),
            onTap: onShare,
          ),
        ),
      ],
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
    return Material(
      color: context.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: ListTileTheme(
        textColor: context.colorScheme.error,
        iconColor: context.colorScheme.error,
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
    );
  }
}
