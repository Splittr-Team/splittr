part of 'group_page.dart';

class _GroupForm extends StatelessWidget {
  const _GroupForm({
    required this.groupId,
    required this.isLoading,
    required this.group,
  });

  final String groupId;
  final Group group;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Expenses list / activity feed placeholder
        Expanded(
          child: AppRefreshIndicator(
            onRefresh: () async {
              getBloc<GroupBloc>(context).started(
                GroupParams(groupId: groupId),
              );
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xxl * 2,
                  ),
                  child: Center(
                    // TODO(Chaitanya): Add expenses
                    child: AppText.bodyMedium(
                      context.strings.expensesWillAppearHere,
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
