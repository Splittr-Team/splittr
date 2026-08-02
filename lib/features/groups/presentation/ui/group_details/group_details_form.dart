part of 'group_details_page.dart';

class _GroupDetailsForm extends StatelessWidget {
  const _GroupDetailsForm({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: () async {
        context.read<GroupDetailsBloc>().started(
          GroupDetailsParams(groupId: group.id ?? '', group: group),
        );
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _InviteCodeCard(inviteCode: group.inviteCode ?? ''),
          const SizedBox(height: AppSpacing.md),
          _InviteLinkCard(inviteCode: group.inviteCode ?? ''),
          const SizedBox(height: AppSpacing.xl),
          const _DeleteGroupCard(),
        ],
      ),
    );
  }
}

class _InviteCodeCard extends StatelessWidget {
  const _InviteCodeCard({required this.inviteCode});

  final String inviteCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.labelMedium(
                context.strings.inviteCode,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText.bodyMedium(inviteCode),
            ],
          ),
          IconButton.filledTonal(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: inviteCode));

              if (context.mounted) {
                AppSnackBar.show(
                  context,
                  message: context.strings.inviteCodeCopied,
                );
              }
            },
            icon: const AppIcon.md(Icons.copy_rounded),
            tooltip: context.strings.copyCode,
          ),
        ],
      ),
    );
  }
}

class _InviteLinkCard extends StatelessWidget {
  const _InviteLinkCard({required this.inviteCode});

  final String inviteCode;

  @override
  Widget build(BuildContext context) {
    final inviteLink = JoinGroupRoute(inviteCode).toDeepLink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelMedium(
                  context.strings.inviteLink,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText.bodyMedium(
                  inviteLink,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton.filledTonal(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: inviteLink));

              if (context.mounted) {
                AppSnackBar.show(
                  context,
                  message: context.strings.inviteLinkCopied,
                );
              }
            },
            icon: const AppIcon.md(Icons.link_rounded),
            tooltip: context.strings.copyLink,
          ),
        ],
      ),
    );
  }
}

class _DeleteGroupCard extends StatelessWidget {
  const _DeleteGroupCard();

  @override
  Widget build(BuildContext context) {
    return AppButton.outlined(
      icon: Icons.delete_outline_rounded,
      text: context.strings.deleteGroup,
      onPressed: () => _confirmDelete(context),
    );
  }
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
            context.read<GroupDetailsBloc>().deleteGroup();
          },
          text: context.strings.delete,
          color: context.colorScheme.error,
        ),
      ],
    ),
  );
}
