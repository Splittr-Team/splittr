part of 'add_friend_bloc.dart';

@freezed
sealed class AddFriendState extends BaseState with _$AddFriendState {
  const AddFriendState._();

  const factory AddFriendState.initial({
    required AddFriendStateStore store,
  }) = Initial;

  const factory AddFriendState.onEmailOrPhoneChange({
    required AddFriendStateStore store,
  }) = OnEmailOrPhoneChange;

  const factory AddFriendState.onFailure({
    required AddFriendStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory AddFriendState.onAddFriendSuccess({
    required AddFriendStateStore store,
    required Friend friend,
  }) = OnAddFriendSuccess;

  const factory AddFriendState.changeLoaderState({
    required AddFriendStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      AddFriendState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      AddFriendState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class AddFriendStateStore with _$AddFriendStateStore {
  const AddFriendStateStore({
    this.loading = false,
    this.emailOrPhone = '',
  });

  @override
  final bool loading;

  @override
  final String emailOrPhone;
}
