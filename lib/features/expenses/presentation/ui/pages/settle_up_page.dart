import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/app_config/domain/stores/app_config_store.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/expenses/presentation/blocs/settle_expense/settle_expense_bloc.dart';
import 'package:splittr/features/profile/presentation/ui/widgets/currency_picker_bottom_sheet.dart';

class SettleUpPage extends BasePage<SettleExpenseBloc, SettleExpenseState> {
  const SettleUpPage({
    this.args,
    super.key,
  });

  final SettleUpArgs? args;

  @override
  SettleExpenseBloc createBloc() {
    final defaultCurr =
        args?.currency ??
        getIt<AuthBloc>().state.user?.defaultCurrency ??
        getIt<AppConfigStore>().userPreferredCurrency ??
        getIt<AppConfigStore>().defaultCurrency;

    return getIt<SettleExpenseBloc>()..started(
      SettleExpenseBlocParams(
        amount: args?.amount,
        currency: defaultCurr,
        paidBy: args?.payerId,
        receivedBy: args?.receiverId,
        groupId: args?.groupId,
      ),
    );
  }

  @override
  bool showLoading(SettleExpenseState state) => state.store.loading;

  @override
  void handleStateChange(BuildContext context, SettleExpenseState state) {
    return switch (state) {
      OnSettleSuccess(:final expense) => {
        AppSnackBar.show(
          context,
          message:
              'Settlement of ${expense.currency} '
              '${expense.amount.toStringAsFixed(2)} completed!',
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
    return BlocBuilder<SettleExpenseBloc, SettleExpenseState>(
      builder: (context, state) {
        final bloc = getBloc<SettleExpenseBloc>(context);
        final store = state.store;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Settle Up'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon and headline
                Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: context.colorScheme.primaryContainer,
                    foregroundColor: context.colorScheme.onPrimaryContainer,
                    child: const AppIcon.lg(Icons.handshake_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppText.headlineSmall(
                  'Record a Payment',
                  color: context.colorScheme.onSurface,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Settlement Direction Card
                Builder(
                  builder: (context) {
                    final currentUserId =
                        getIt<AuthBloc>().state.user?.id ??
                        getIt<FirebaseAuth>().currentUser?.uid;

                    String resolveName(String id, String? explicitName) {
                      if (id.isEmpty) return 'Not set';
                      if (id == currentUserId) return 'You';
                      if (explicitName != null && explicitName.isNotEmpty) {
                        return explicitName;
                      }
                      if (id == args?.payerId &&
                          args?.payerName != null &&
                          args!.payerName!.isNotEmpty) {
                        return args!.payerName!;
                      }
                      if (id == args?.receiverId &&
                          args?.receiverName != null &&
                          args!.receiverName!.isNotEmpty) {
                        return args!.receiverName!;
                      }
                      return id;
                    }

                    final payerDisplayName = resolveName(
                      store.paidBy,
                      store.paidBy == args?.payerId
                          ? args?.payerName
                          : (store.paidBy == args?.receiverId
                                ? args?.receiverName
                                : null),
                    );

                    final receiverDisplayName = resolveName(
                      store.receivedBy,
                      store.receivedBy == args?.payerId
                          ? args?.payerName
                          : (store.receivedBy == args?.receiverId
                                ? args?.receiverName
                                : null),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppCard.outlined(
                          color: context.colorScheme.surfaceContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.labelSmall(
                                        'Paid by',
                                        color: context
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      AppText.titleMedium(
                                        payerDisplayName,
                                        color: context.colorScheme.onSurface,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const AppIcon.md(
                                    Icons.swap_horiz_rounded,
                                  ),
                                  tooltip: 'Swap direction',
                                  onPressed: () {
                                    final oldPaid = store.paidBy;
                                    final oldReceived = store.receivedBy;
                                    bloc
                                      ..paidByChanged(paidBy: oldReceived)
                                      ..receivedByChanged(receivedBy: oldPaid);
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText.labelSmall(
                                        'Paid to',
                                        color: context
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      AppText.titleMedium(
                                        receiverDisplayName,
                                        color: context.colorScheme.onSurface,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (store.paidBy.isEmpty ||
                            store.receivedBy.isEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            initialValue: store.paidBy,
                            labelText: 'Paid by (User ID)',
                            hintText: 'User ID of who paid',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                              ),
                              child: AppIcon.md(Icons.person_rounded),
                            ),
                            onChanged: (val) => bloc.paidByChanged(paidBy: val),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            initialValue: store.receivedBy,
                            labelText: 'Paid to (User ID)',
                            hintText: 'User ID of who received',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                              ),
                              child: AppIcon.md(Icons.person_outline_rounded),
                            ),
                            onChanged: (val) =>
                                bloc.receivedByChanged(receivedBy: val),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Amount and Currency
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      child: InkWell(
                        onTap: () {
                          unawaited(
                            AppBottomSheet.show<void>(
                              context: context,
                              title: 'Select Currency',
                              child: CurrencyPickerBottomSheet(
                                selectedCurrency: store.currency,
                                onCurrencySelected: (val) =>
                                    bloc.currencyChanged(currency: val),
                              ),
                            ),
                          );
                        },
                        child: IgnorePointer(
                          child: AppTextField(
                            key: ValueKey(store.currency),
                            initialValue: store.currency,
                            labelText: 'Currency',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        initialValue: store.amount > 0
                            ? store.amount.toString()
                            : '',
                        labelText: 'Amount',
                        hintText: '0.00',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: AppIcon.md(Icons.attach_money_rounded),
                        ),
                        onChanged: (val) {
                          final parsed = num.tryParse(val) ?? 0;
                          bloc.amountChanged(amount: parsed);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: context.colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: AppButton.primary(
                text: 'Record Settlement',
                onPressed: store.isValid ? bloc.submit : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
