import 'package:flutter/material.dart' hide Notification;
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/presentation/widgets/paginated_list_view.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';
import 'package:splittr/features/notifications/presentation/blocs/notifications_bloc.dart';
import 'package:splittr/features/notifications/presentation/ui/widgets/notification_list_tile.dart';
import 'package:splittr/features/notifications/presentation/ui/widgets/notifications_shimmer_loader.dart';

part 'notifications_form.dart';

/// Page that displays the user's notification list with mark-all-read support.
class NotificationsPage
    extends BasePage<NotificationsBloc, NotificationsState> {
  const NotificationsPage({super.key});

  @override
  NotificationsBloc createBloc() =>
      getIt<NotificationsBloc>()..started(noParams);

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Notifications',
        actions: [
          BlocSelector<NotificationsBloc, NotificationsState, bool>(
            selector: (state) => state.store.notifications.any(
              (notification) => !(notification.isRead ?? false),
            ),
            builder: (context, hasUnread) {
              return AppIconButton(
                icon: Icons.done_all,
                onPressed: hasUnread
                    ? () => getBloc<NotificationsBloc>(context).markAllRead()
                    : null,
              );
            },
          ),
        ],
      ),
      body: const _NotificationsForm(),
    );
  }
}
