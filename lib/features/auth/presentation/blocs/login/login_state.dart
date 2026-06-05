part of 'login_bloc.dart';

@freezed
sealed class LoginState extends BaseState with _$LoginState {
  const LoginState._();

  const factory LoginState.initial({
    required LoginStateStore store,
  }) = Initial;

  const factory LoginState.onLoadingStateChange({
    required LoginStateStore store,
  }) = OnLoadingStateChange;

  const factory LoginState.onFailure({
    required LoginStateStore store,
    required Failure failure,
  }) = OnFailure;

  @override
  BaseState getLoadingState({required bool loading}) {
    return LoginState.onLoadingStateChange(
      store: store.copyWith(loading: loading),
    );
  }

  @override
  BaseState getFailureState({required Failure failure}) {
    return LoginState.onFailure(
      store: store.copyWith(loading: false),
      failure: failure,
    );
  }
}

@freezed
class LoginStateStore with _$LoginStateStore {
  const LoginStateStore({
    this.loading = false,
  });

  @override
  final bool loading;
}
