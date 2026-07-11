part of 'auth_bloc.dart';

@freezed
sealed class AuthState extends BaseState with _$AuthState {
  const AuthState._();

  const factory AuthState.loading() = Loading;

  const factory AuthState.onUserAuthenticated({
    required User user,
  }) = OnUserAuthenticated;

  const factory AuthState.onUserUnauthenticated() = OnUserUnauthenticated;

  const factory AuthState.guest() = Guest;

  const factory AuthState.onLogout() = OnLogout;

  const factory AuthState.onFailure({
    required Failure failure,
  }) = OnFailure;

  @override
  BaseState getLoadingState({required bool loading}) {
    return const AuthState.loading();
  }

  @override
  BaseState getFailureState({required Failure failure}) {
    return AuthState.onFailure(failure: failure);
  }
}
