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
    final currentUserId = getBloc<AuthBloc>(context).state.user?.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GroupBalanceSummaryHeader(
          groupId: groupId,
          group: group,
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
          child: BlocBuilder<ExpensesBloc, ExpensesState>(
            builder: (context, expensesState) {
              final expensesBloc = getBloc<ExpensesBloc>(context);
              final expenses = expensesState.store.expenses;
              final hasMore = expensesState.store.hasMore;
              final isExpensesLoading = expensesState.store.loading;

              if (expenses.isEmpty && !isExpensesLoading) {
                return AppRefreshIndicator(
                  onRefresh: () async {
                    getBloc<GroupBloc>(context).started(
                      GroupParams(groupId: groupId),
                    );
                    expensesBloc.started(
                      ExpensesParams(groupId: groupId),
                    );
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.xxl,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor:
                                    context.colorScheme.surfaceContainerHigh,
                                foregroundColor:
                                    context.colorScheme.onSurfaceVariant,
                                child: const AppIcon.lg(
                                  Icons.receipt_long_outlined,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              AppText.titleMedium(
                                context.strings.noExpensesYet,
                                color: context.colorScheme.onSurface,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              AppText.bodyMedium(
                                context.strings.noExpensesGroupSubtitle,
                                color: context.colorScheme.onSurfaceVariant,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ExpensesListView(
                expenses: expenses,
                hasMore: hasMore,
                isLoadingMore: isExpensesLoading && expenses.isNotEmpty,
                currentUserId: currentUserId,
                onLoadMore: expensesBloc.fetchNextPage,
                onRefresh: () async {
                  getBloc<GroupBloc>(context).started(
                    GroupParams(groupId: groupId),
                  );
                  expensesBloc.started(
                    ExpensesParams(groupId: groupId),
                  );
                },
                onExpenseTap: (expense) {
                  unawaited(
                    ExpenseDetailsRoute(
                      expenseId: expense.id,
                    ).push<void>(context),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
