import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';

class SummaryBottomSheet extends StatelessWidget {
  const SummaryBottomSheet({required this.summaryMap, super.key});

  final Map<String, List<Map<String, num>>> summaryMap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: summaryMap.entries.map<Widget>((entry) {
        final receiver = entry.key;
        final givers = List<Map<String, num>>.from(entry.value);

        return Card(
          margin: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AppText.titleMedium(
                    receiver,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Column(
                  children: givers.map<Widget>((giverMap) {
                    final giver = giverMap.keys.first;
                    final amount = giverMap.values.first;
                    final displayAmount = amount < 0 ? (amount * -1) : amount;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xs,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.bodyMedium(giver),
                          AppText.bodyMedium(
                            '${displayAmount.toStringAsFixed(2)} Rs',
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
