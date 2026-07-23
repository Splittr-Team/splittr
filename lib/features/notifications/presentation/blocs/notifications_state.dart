part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsState extends BaseState with _$NotificationsState {
  const NotificationsState._();

  const factory NotificationsState.initial({
    required NotificationsStateStore store,
  }) = Initial;

  const factory NotificationsState.onNotificationsUpdate({
    required NotificationsStateStore store,
  }) = OnNotificationsUpdate;

  const factory NotificationsState.onFailure({
    required NotificationsStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory NotificationsState.changeLoaderState({
    required NotificationsStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      NotificationsState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      NotificationsState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class NotificationsStateStore with _$NotificationsStateStore {
  const NotificationsStateStore({
    required this.notifications,
    this.loading = false,
    this.hasMore = false,
    this.nextCursor,
  });

  @override
  final bool loading;

  @override
  final List<Notification> notifications;

  @override
  final bool hasMore;

  @override
  final String? nextCursor;
}
