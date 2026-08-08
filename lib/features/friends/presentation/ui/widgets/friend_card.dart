import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    required this.name,
    required this.email,
    this.phone,
    this.onTap,
    super.key,
  });

  final String name;
  final String email;
  final String? phone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
        : '?';

    return AppCard.outlined(
      color: context.colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: AppBorderRadius.lg,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              AppAvatar(
                initials: initials,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.titleMedium(
                      name,
                      color: context.colorScheme.onSurface,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (email.isNotEmpty &&
                        phone != null &&
                        phone!.isNotEmpty) ...[
                      AppText.bodyMedium(
                        email,
                        color: context.colorScheme.onSurfaceVariant,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText.bodyMedium(
                        phone!,
                        color: context.colorScheme.onSurfaceVariant,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else ...[
                      AppText.bodyMedium(
                        email.isNotEmpty ? email : (phone ?? ''),
                        color: context.colorScheme.onSurfaceVariant,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AppIcon.md(
                Icons.chevron_right_rounded,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendCardShimmer extends StatelessWidget {
  const FriendCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard.outlined(
      color: context.colorScheme.surfaceContainer,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            AppShimmer.circle(size: AppRadius.lgIncreased * 2),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppShimmer(
                    width: 120,
                    height: 16,
                    borderRadius: AppBorderRadius.xs,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AppShimmer(
                    width: 160,
                    height: 12,
                    borderRadius: AppBorderRadius.xs,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md),
            AppShimmer.circle(size: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
