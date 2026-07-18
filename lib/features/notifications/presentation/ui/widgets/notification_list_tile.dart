import 'package:flutter/material.dart' hide Notification;
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';

/// A tile widget that displays a single notification with read/unread state.
class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    required this.notification,
    required this.onMarkRead,
    super.key,
  });

  final Notification notification;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    final isUnread = !(notification.isRead ?? false);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: const RoundedRectangleBorder(
        borderRadius: AppBorderRadius.md,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: SizedBox.square(
          dimension: AppSpacing.xl,
          child: AppAvatar(
            initials: (notification.actorName ?? '?').isNotEmpty
                ? notification.actorName![0].toUpperCase()
                : '?',
          ),
        ),
        title: isUnread
            ? AppText.titleMedium(notification.title ?? '')
            : AppText.bodyLarge(notification.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            AppText.bodyMedium(
              notification.content ?? '',
              color: isUnread ? null : context.colorScheme.onSurfaceVariant,
            ),
            if (notification.createdAt case final DateTime createdAt) ...[
              const SizedBox(height: AppSpacing.xs),
              AppText.labelSmall(
                createdAt.toLocal().toString().substring(0, 16),
                color: context.colorScheme.outline,
              ),
            ],
          ],
        ),
        trailing: isUnread
            ? AppIconButton(
                icon: Icons.mark_email_read_outlined,
                onPressed: onMarkRead,
              )
            : null,
      ),
    );
  }
}
