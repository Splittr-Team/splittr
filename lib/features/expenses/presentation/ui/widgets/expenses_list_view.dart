import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/presentation/widgets/paginated_list_view.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/presentation/ui/widgets/expense_card.dart';

class ExpensesListView extends StatelessWidget {
  const ExpensesListView({
    required this.expenses,
    required this.hasMore,
    required this.isLoadingMore,
    this.onLoadMore,
    this.onRefresh,
    this.currentUserId,
    this.onExpenseTap,
    this.padding,
    super.key,
  });

  final List<Expense> expenses;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final RefreshCallback? onRefresh;
  final String? currentUserId;
  final ValueChanged<Expense>? onExpenseTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final listView = PaginatedListView<Expense>(
      items: expenses,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      onLoadMore: onLoadMore ?? () {},
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, expense, index) {
        return ExpenseCard(
          expense: expense,
          currentUserId: currentUserId,
          onTap: onExpenseTap != null ? () => onExpenseTap!(expense) : null,
        );
      },
    );

    if (onRefresh != null) {
      return AppRefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}
