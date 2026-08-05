import 'dart:async';

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
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: context.colorScheme.onSurface.withValues(
                  alpha: 0.08,
                ),
                foregroundColor: context.colorScheme.onSurfaceVariant,
                child: AppText.titleMedium(
                  initials,
                  color: context.colorScheme.onSurfaceVariant,
                ),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    AppText.bodyMedium(
                      email.isNotEmpty ? email : (phone ?? ''),
                      color: context.colorScheme.onSurfaceVariant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
            SkeletonPlaceholder(
              width: 44,
              height: 44,
              borderRadius: 22,
            ),
            SizedBox(width: AppSpacing.md),
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
            SkeletonPlaceholder(
              width: 24,
              height: 24,
              borderRadius: 12,
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
