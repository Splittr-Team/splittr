import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';

class PayerItem {
  const PayerItem({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;
}

class PayerSelectorBottomSheet extends StatelessWidget {
  const PayerSelectorBottomSheet({
    required this.payers,
    required this.selectedPayerId,
    required this.onPayerSelected,
    super.key,
  });

  final List<PayerItem> payers;
  final String selectedPayerId;
  final ValueChanged<String> onPayerSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: AppText.titleLarge(
            'Who paid?',
            color: context.colorScheme.onSurface,
          ),
        ),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            itemCount: payers.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.xs),
            itemBuilder: (context, index) {
              final payer = payers[index];
              final isSelected = payer.id == selectedPayerId;
              final initials = payer.name.isNotEmpty
                  ? payer.name
                        .trim()
                        .split(' ')
                        .map((l) => l[0])
                        .take(2)
                        .join()
                        .toUpperCase()
                  : '?';

              return ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.md,
                ),
                tileColor: isSelected
                    ? context.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      )
                    : null,
                leading: AppAvatar(
                  initials: initials,
                ),
                title: AppText.bodyLarge(
                  payer.name,
                  color: context.colorScheme.onSurface,
                ),
                subtitle: payer.email != null
                    ? AppText.bodySmall(
                        payer.email!,
                        color: context.colorScheme.onSurfaceVariant,
                      )
                    : null,
                trailing: isSelected
                    ? AppIcon.md(
                        Icons.check_circle_rounded,
                        color: context.colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  onPayerSelected(payer.id);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
