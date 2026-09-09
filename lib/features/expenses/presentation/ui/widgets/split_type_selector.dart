import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/features/expenses/domain/entities/split_type.dart';

class SplitTypeSelector extends StatelessWidget {
  const SplitTypeSelector({
    required this.selectedType,
    required this.onTypeChanged,
    super.key,
  });

  final SplitType selectedType;
  final ValueChanged<SplitType> onTypeChanged;

  String _getTitle(SplitType type) {
    return switch (type) {
      SplitType.equal => 'Equally (=)',
      SplitType.exact => r'Exact ($)',
      SplitType.percentage => 'Percent (%)',
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: SplitType.values.map((type) {
          final isSelected = type == selectedType;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: AppText.labelMedium(
                _getTitle(type),
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurface,
              ),
              selected: isSelected,
              selectedColor: context.colorScheme.primary,
              backgroundColor: context.colorScheme.surfaceContainerHigh,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.md,
                side: BorderSide(
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.outlineVariant,
                ),
              ),
              onSelected: (_) => onTypeChanged(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}
