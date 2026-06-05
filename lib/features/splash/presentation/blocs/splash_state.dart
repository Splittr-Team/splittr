part of 'splash_bloc.dart';

@freezed
sealed class SplashState extends BaseState with _$SplashState {
  const SplashState._();

  const factory SplashState.initial({required SplashStateStore store}) =
      Initial;

  const factory SplashState.onCheckAuthStatus({
    required SplashStateStore store,
  }) = OnCheckAuthStatus;

  const factory SplashState.onUserAuthorize({
    required SplashStateStore store,
  }) = OnUserAuthorize;

  const factory SplashState.onUserUnauthorize({
    required SplashStateStore store,
  }) = OnUserUnauthorize;

  const factory SplashState.onLoadingStateChange({
    required SplashStateStore store,
  }) = OnLoadingStateChange;

  const factory SplashState.onFailure({
    required SplashStateStore store,
    required Failure failure,
  }) = OnFailure;

  @override
  BaseState getLoadingState({required bool loading}) =>
      SplashState.onLoadingStateChange(store: store.copyWith(loading: loading));

  @override
  BaseState getFailureState({required Failure failure}) =>
      SplashState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );
}

@freezed
class SplashStateStore with _$SplashStateStore {
  const SplashStateStore({this.loading = false});

  @override
  final bool loading;
}
