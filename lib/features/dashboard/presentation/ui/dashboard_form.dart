part of 'dashboard_page.dart';

class _DashboardForm extends StatelessWidget {
  const _DashboardForm();

  @override
  Widget build(BuildContext context) {
    final currentUserId = getBloc<AuthBloc>(context).state.user?.id;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.store.loading &&
            state.store.balances == null &&
            state.store.recentExpenses.isEmpty &&
            state.store.recentActivities.isEmpty) {
          return const ExpensesShimmerList();
        }

        final balances = state.store.balances;
        final recentExpenses = state.store.recentExpenses;
        final recentActivities = state.store.recentActivities;
        final currency =
            balances?.balances.firstOrNull?.currency ??
            getBloc<AuthBloc>(context).state.user?.defaultCurrency ??
            getIt<AppConfigStore>().userPreferredCurrency ??
            getIt<AppConfigStore>().defaultCurrency;

        return AppRefreshIndicator(
          onRefresh: () async {
            getBloc<DashboardBloc>(context).refresh();
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              TotalBalanceCard(
                balances: balances,
                currency: currency,
              ),
              const SizedBox(height: AppSpacing.md),
              const QuickActionsBar(),
              const SizedBox(height: AppSpacing.lg),
              _buildRecentExpensesSection(
                context: context,
                expenses: recentExpenses,
                currentUserId: currentUserId,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildRecentActivitiesSection(
                context: context,
                activities: recentActivities,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentExpensesSection({
    required BuildContext context,
    required List<Expense> expenses,
    required String? currentUserId,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.titleMedium(
              'Recent Transactions',
              color: context.colorScheme.onSurface,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (expenses.isEmpty)
          AppCard.outlined(
            color: context.colorScheme.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: AppText.bodyMedium(
                  'No recent expenses yet.',
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...expenses
              .take(5)
              .map(
                (expense) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ExpenseCard(
                    expense: expense,
                    currentUserId: currentUserId,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildRecentActivitiesSection({
    required BuildContext context,
    required List<Activity> activities,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.titleMedium(
              context.strings.activity,
              color: context.colorScheme.onSurface,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (activities.isEmpty)
          AppCard.outlined(
            color: context.colorScheme.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: AppText.bodyMedium(
                  context.strings.noRecentActivity,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...activities
              .take(5)
              .map(
                (activity) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ActivityItemCard(
                    activity: activity,
                  ),
                ),
              ),
      ],
    );
  }
}
