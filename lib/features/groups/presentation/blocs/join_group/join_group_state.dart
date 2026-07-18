part of 'join_group_cubit.dart';

@freezed
sealed class JoinGroupState extends BaseState with _$JoinGroupState {
  const JoinGroupState._();

  const factory JoinGroupState.joinGroupInitial() = JoinGroupInitial;

  const factory JoinGroupState.joinGroupLoading() = JoinGroupLoading;

  const factory JoinGroupState.joinGroupSuccess({
    required Group group,
  }) = JoinGroupSuccess;

  const factory JoinGroupState.joinGroupFailure({
    required Failure failure,
  }) = JoinGroupFailure;

  @override
  BaseState getFailureState({required Failure failure}) =>
      JoinGroupState.joinGroupFailure(failure: failure);

  @override
  BaseState getLoadingState({required bool loading}) => loading
      ? const JoinGroupState.joinGroupLoading()
      : const JoinGroupState.joinGroupInitial();
}
