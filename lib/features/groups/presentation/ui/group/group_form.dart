part of 'group_page.dart';

class _GroupForm extends StatelessWidget {
  const _GroupForm({
    required this.groupId,
    required this.isLoading,
    this.group,
  });

  final String groupId;
  final Group? group;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final displayGroup = group ?? Group(id: groupId, name: 'Group $groupId');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Card
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.colorScheme.outlineVariant,
              ),
            ),
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
                        displayGroup.name ?? context.strings.groupDetails,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText.bodyMedium(
                        context.strings.membersCount(
                          displayGroup.members.length,
                        ),
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expenses list / activity feed placeholder
        Expanded(
          child: AppRefreshIndicator(
            onRefresh: () async {
              getBloc<GroupBloc>(context).started(groupId);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 300,
                  child: Center(
                    // TODO(Chaitanya): Add expenses
                    child: AppText.bodyMedium(
                      'Expenses will appear here', // Add to app_en.arb later
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
