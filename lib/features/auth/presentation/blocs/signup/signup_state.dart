part of 'signup_bloc.dart';

@freezed
sealed class SignupState extends BaseState with _$SignupState {
  const SignupState._();

  const factory SignupState.initial({
    required SignupStateStore store,
  }) = Initial;

  const factory SignupState.onLoadingStateChange({
    required SignupStateStore store,
  }) = OnLoadingStateChange;

  const factory SignupState.onFailure({
    required SignupStateStore store,
    required Failure failure,
  }) = OnFailure;

  @override
  SignupState getLoadingState({required bool loading}) {
    return SignupState.onLoadingStateChange(
      store: store.copyWith(loading: loading),
    );
  }

  @override
  SignupState getFailureState({required Failure failure}) {
    return SignupState.onFailure(
      store: store.copyWith(loading: false),
      failure: failure,
    );
  }
}

@freezed
class SignupStateStore with _$SignupStateStore {
  const SignupStateStore({
    this.loading = false,
  });

  @override
  final bool loading;
}
