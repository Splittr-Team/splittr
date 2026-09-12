import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/features/expenses/presentation/ui/widgets/expense_card.dart';

class ExpensesShimmerList extends StatelessWidget {
  const ExpensesShimmerList({
    this.itemCount = 8,
    this.padding,
    super.key,
  });

  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      itemCount: itemCount,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return const ExpenseCardShimmer();
      },
    );
  }
}
