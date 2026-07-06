part of 'auth_bloc.dart';

@freezed
sealed class AuthState extends BaseState with _$AuthState {
  const AuthState._();

  const factory AuthState.initial({
    required AuthStateStore store,
  }) = Initial;

  const factory AuthState.authenticated({
    required AuthStateStore store,
    required User user,
  }) = Authenticated;

  const factory AuthState.guest({
    required AuthStateStore store,
  }) = Guest;

  const factory AuthState.onUserUnauthenticated({
    required AuthStateStore store,
  }) = OnUserUnauthenticated;

  const factory AuthState.onLogout({
    required AuthStateStore store,
  }) = OnLogout;

  const factory AuthState.onLoadingStateChange({
    required AuthStateStore store,
  }) = OnLoadingStateChange;

  const factory AuthState.onFailure({
    required AuthStateStore store,
    required Failure failure,
  }) = OnFailure;

  @override
  BaseState getLoadingState({required bool loading}) {
    return AuthState.onLoadingStateChange(
      store: store.copyWith(loading: loading),
    );
  }

  @override
  BaseState getFailureState({required Failure failure}) {
    return AuthState.onFailure(
      store: store.copyWith(loading: false),
      failure: failure,
    );
  }
}

@freezed
class AuthStateStore with _$AuthStateStore {
  const AuthStateStore({this.loading = false});

  @override
  final bool loading;
}
