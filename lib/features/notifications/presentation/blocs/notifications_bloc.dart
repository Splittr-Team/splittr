import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';
import 'package:splittr/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:splittr/features/notifications/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:splittr/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:splittr/features/notifications/domain/usecases/watch_notifications_usecase.dart';

part 'notifications_bloc.freezed.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

@injectable
final class NotificationsBloc
    extends BaseBloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(
    this._getNotificationsUseCase,
    this._watchNotificationsUseCase,
    this._markAllNotificationsAsReadUseCase,
    this._markNotificationAsReadUseCase,
  ) : super(
        const NotificationsState.initial(
          store: NotificationsStateStore(notifications: []),
        ),
      ) {
    _listenToRepositoryStream();
  }

  final GetNotificationsUseCase _getNotificationsUseCase;
  final WatchNotificationsUseCase _watchNotificationsUseCase;
  final MarkAllNotificationsAsReadUseCase _markAllNotificationsAsReadUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;

  StreamSubscription<EitherFailure<List<Notification>>>?
  _notificationsSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_NotificationsUpdated>(_onNotificationsUpdated);
    on<_NotificationsFailed>(_onNotificationsFailed);
    on<_MarkAllRead>(_onMarkAllRead);
    on<_MarkRead>(_onMarkRead);
  }

  void _listenToRepositoryStream() {
    _notificationsSubscription = _watchNotificationsUseCase
        .call(noParams)
        .listen(
          (result) => result.fold(
            (failure) =>
                add(NotificationsEvent.notificationsFailed(failure: failure)),
            (notifications) => add(
              NotificationsEvent.notificationsUpdated(
                notifications: notifications,
              ),
            ),
          ),
        );
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<NotificationsState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _getNotificationsUseCase.call(noParams);

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) => changeLoadingState(emit: emit, loading: false),
    );
  }

  void _onNotificationsUpdated(
    _NotificationsUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    emit(
      NotificationsState.onNotificationsUpdate(
        store: state.store.copyWith(
          notifications: event.notifications,
        ),
      ),
    );
  }

  void _onNotificationsFailed(
    _NotificationsFailed event,
    Emitter<NotificationsState> emit,
  ) {
    handleFailure(emit: emit, failure: event.failure);
  }

  FutureOr<void> _onMarkAllRead(
    _MarkAllRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _markAllNotificationsAsReadUseCase.call(noParams);

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) {},
    );
  }

  FutureOr<void> _onMarkRead(
    _MarkRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _markNotificationAsReadUseCase.call(event.id);

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) {},
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const NotificationsEvent.started());
  }

  /// Triggers a refresh of the notifications list.
  void refreshNotifications() {
    add(const NotificationsEvent.started());
  }

  /// Marks all notifications as read.
  void markAllRead() {
    add(const NotificationsEvent.markAllRead());
  }

  /// Marks a single notification as read by [id].
  void markRead({required String id}) {
    add(NotificationsEvent.markRead(id: id));
  }

  @override
  Future<void> close() async {
    await _notificationsSubscription?.cancel();
    return super.close();
  }
}
