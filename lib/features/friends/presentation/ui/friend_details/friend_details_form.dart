part of 'friend_details_page.dart';

class FriendDetailsForm extends StatelessWidget {
  const FriendDetailsForm({
    required this.friendId,
    this.friend,
    super.key,
  });

  final String friendId;
  final Friend? friend;

  @override
  Widget build(BuildContext context) {
    final currentUserId = getBloc<AuthBloc>(context).state.user?.id;
    final friendName = friend?.name ?? 'Friend';

    return BlocBuilder<FriendDetailsBloc, FriendDetailsState>(
      builder: (context, state) {
        final bloc = getBloc<FriendDetailsBloc>(context);
        final balances = state.store.balances;

        // Calculate pairwise balance
        var net = 0.0;
        var currency = r'$';

        final directSettlementFromFriend = balances?.directSettlements
            .where(
              (s) => s.fromUserId == friendId && s.toUserId == currentUserId,
            )
            .firstOrNull;
        final directSettlementToFriend = balances?.directSettlements
            .where(
              (s) => s.fromUserId == currentUserId && s.toUserId == friendId,
            )
            .firstOrNull;

        if (directSettlementFromFriend != null) {
          net = directSettlementFromFriend.amount.toDouble();
          currency = directSettlementFromFriend.currency ?? r'$';
        } else if (directSettlementToFriend != null) {
          net = -directSettlementToFriend.amount.toDouble();
          currency = directSettlementToFriend.currency ?? r'$';
        } else {
          final userBalance = balances?.balances
              .where(
                (b) => b.userId == friendId,
              )
              .firstOrNull;
          if (userBalance != null) {
            net = userBalance.netBalance.toDouble();
            currency = userBalance.currency ?? r'$';
          }
        }

        final BalanceState balanceState;
        if (net > 0.001) {
          balanceState = BalanceState.owed;
        } else if (net < -0.001) {
          balanceState = BalanceState.owes;
        } else {
          balanceState = BalanceState.settled;
        }

        final isDark = context.colorScheme.brightness == Brightness.dark;
        Color statusColor;
        String statusText;

        switch (balanceState) {
          case BalanceState.owed:
            statusColor = isDark
                ? Colors.greenAccent.shade400
                : Colors.green.shade700;
            statusText = '$friendName ${context.strings.owesYou}';
          case BalanceState.owes:
            statusColor = context.colorScheme.error;
            statusText = '${context.strings.youOwe} $friendName';
          case BalanceState.settled:
            statusColor = context.colorScheme.onSurfaceVariant.withValues(
              alpha: 0.7,
            );
            statusText = context.strings.allSettledUp;
        }

        final amountText = '$currency${net.abs().toStringAsFixed(2)}';

        final expenses = state.store.expenses;
        final hasMore = state.store.hasMore;
        final isLoading = state.store.loading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top balance summary card
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: AppCard.outlined(
                color: context.colorScheme.surfaceContainerHigh,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: statusColor.withValues(
                              alpha: 0.12,
                            ),
                            foregroundColor: statusColor,
                            child: Icon(
                              balanceState == BalanceState.settled
                                  ? Icons.check_circle_outline_rounded
                                  : (balanceState == BalanceState.owed
                                        ? Icons.arrow_downward_rounded
                                        : Icons.arrow_upward_rounded),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.bodyMedium(
                                  statusText,
                                  color: context.colorScheme.onSurfaceVariant,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (balanceState != BalanceState.settled) ...[
                                  const SizedBox(height: AppSpacing.xs),
                                  AppText.headlineSmall(
                                    amountText,
                                    color: statusColor,
                                  ),
                                ] else ...[
                                  const SizedBox(height: AppSpacing.xs),
                                  AppText.titleLarge(
                                    '$currency 0.00',
                                    color: context.colorScheme.onSurface,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Action buttons: Settle Up & Add Expense
                      Row(
                        children: [
                          Expanded(
                            child: AppButton.secondary(
                              text: context.strings.settleUp,
                              icon: Icons.handshake_outlined,
                              onPressed: () {
                                final isYouOwe =
                                    balanceState == BalanceState.owes;
                                unawaited(
                                  SettleUpRoute(
                                    args: SettleUpArgs(
                                      payerId: isYouOwe
                                          ? currentUserId
                                          : friendId,
                                      receiverId: isYouOwe
                                          ? friendId
                                          : currentUserId,
                                      payerName: isYouOwe ? 'You' : friendName,
                                      receiverName: isYouOwe
                                          ? friendName
                                          : 'You',
                                      amount: net != 0 ? net.abs() : null,
                                      currency: currency,
                                    ),
                                  ).push<void>(context),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppButton.primary(
                              text: context.strings.addExpense,
                              icon: Icons.add_rounded,
                              onPressed: () {
                                unawaited(
                                  AddExpenseRoute(
                                    args: AddExpenseArgs(
                                      friendId: friendId,
                                      participantUserIds: [
                                        ?currentUserId,
                                        friendId,
                                      ],
                                    ),
                                  ).push<void>(context),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Transactions Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: AppText.titleMedium(
                context.strings.expenses,
                color: context.colorScheme.onSurface,
              ),
            ),

            // Expenses List
            Expanded(
              child: expenses.isEmpty && !isLoading
                  ? AppRefreshIndicator(
                      onRefresh: () async {
                        bloc.started(
                          FriendDetailsParams(
                            friendId: friendId,
                            friend: friend,
                          ),
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
                                    backgroundColor: context
                                        .colorScheme
                                        .surfaceContainerHigh,
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
                                    context.strings.noExpensesFriendSubtitle,
                                    color: context.colorScheme.onSurfaceVariant,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ExpensesListView(
                      expenses: expenses,
                      hasMore: hasMore,
                      isLoadingMore: isLoading && expenses.isNotEmpty,
                      currentUserId: currentUserId,
                      onLoadMore: bloc.fetchNextPage,
                      onRefresh: () async {
                        bloc.started(
                          FriendDetailsParams(
                            friendId: friendId,
                            friend: friend,
                          ),
                        );
                      },
                      onExpenseTap: (expense) {
                        unawaited(
                          ExpenseDetailsRoute(
                            expenseId: expense.id,
                          ).push<void>(context),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
