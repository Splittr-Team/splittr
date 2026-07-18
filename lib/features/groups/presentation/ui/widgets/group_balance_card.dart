import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';

enum BalanceState { owed, owes, settled }

class GroupBalanceCard extends StatelessWidget {
  const GroupBalanceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.balanceState,
    required this.amountText,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final BalanceState balanceState;
  final String amountText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.colorScheme.brightness == Brightness.dark;

    Color statusColor;
    String statusText;

    switch (balanceState) {
      case BalanceState.owed:
        // Semantic color for being owed (green/teal)
        statusColor = isDark
            ? Colors.greenAccent.shade400
            : Colors.green.shade700;
        statusText = 'You are owed';
      case BalanceState.owes:
        // Semantic color for owing money (red/orange)
        statusColor = context.colorScheme.error;
        statusText = 'You owe';
      case BalanceState.settled:
        // Muted gray for settled status
        statusColor = context.colorScheme.onSurfaceVariant.withValues(
          alpha: 0.7,
        );
        statusText = 'Settle up';
    }

    return AppCard.outlined(
      color: context.colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Left section: Circular avatar with icon
              CircleAvatar(
                radius: 22,
                backgroundColor: context.colorScheme.onSurface.withValues(
                  alpha: 0.08,
                ),
                foregroundColor: context.colorScheme.onSurfaceVariant,
                child: AppIcon.md(
                  icon,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Middle section: Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Right section: Balance status and amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    statusText,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (balanceState != BalanceState.settled) ...[
                    const SizedBox(height: 4),
                    Text(
                      amountText,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupBalanceCardShimmer extends StatelessWidget {
  const GroupBalanceCardShimmer({super.key});

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
            // Left: circular avatar placeholder
            SkeletonPlaceholder(
              width: 44,
              height: 44,
              borderRadius: 22,
            ),
            SizedBox(width: AppSpacing.md),
            // Middle: title and subtitle placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SkeletonPlaceholder(
                    width: 120,
                    height: 16,
                    borderRadius: 4,
                  ),
                  SizedBox(height: 8),
                  SkeletonPlaceholder(
                    width: 160,
                    height: 12,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md),
            // Right: status and amount placeholder
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonPlaceholder(
                  width: 80,
                  height: 12,
                  borderRadius: 4,
                ),
                SizedBox(height: 8),
                SkeletonPlaceholder(
                  width: 60,
                  height: 16,
                  borderRadius: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonPlaceholder extends StatefulWidget {
  const SkeletonPlaceholder({
    required this.width,
    required this.height,
    this.borderRadius = 8,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<SkeletonPlaceholder> createState() => _SkeletonPlaceholderState();
}

class _SkeletonPlaceholderState extends State<SkeletonPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    unawaited(_controller.repeat(reverse: true));
    _animation = Tween<double>(begin: 0.05, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: context.colorScheme.onSurface.withValues(
              alpha: _animation.value,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
