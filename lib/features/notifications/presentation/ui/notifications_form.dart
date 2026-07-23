part of 'notifications_page.dart';

class _NotificationsForm extends StatelessWidget {
  const _NotificationsForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        return switch (state) {
          Initial _ ||
          ChangeLoaderState _ => const NotificationsShimmerLoader(),

          OnFailure(:final failure) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppText.bodyMedium(
                failure.message,
                color: context.colorScheme.error,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          OnNotificationsUpdate _ =>
            state.store.notifications.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: AppText.bodyMedium(
                        'No notifications yet!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      getBloc<NotificationsBloc>(
                        context,
                      ).refreshNotifications();
                    },
                    child: PaginatedListView<Notification>(
                      items: state.store.notifications,
                      hasMore: state.store.hasMore,
                      isLoadingMore: state.store.loading,
                      onLoadMore: () =>
                          getBloc<NotificationsBloc>(context).fetchNextPage(),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, notification, index) {
                        return NotificationListTile(
                          notification: notification,
                          onMarkRead: () {
                            if (notification.id case final String id) {
                              getBloc<NotificationsBloc>(
                                context,
                              ).markRead(id: id);
                            }
                          },
                        );
                      },
                    ),
                  ),
        };
      },
    );
  }
}
