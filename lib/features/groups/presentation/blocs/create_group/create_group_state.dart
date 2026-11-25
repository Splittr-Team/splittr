part of 'create_group_bloc.dart';

@freezed
sealed class CreateGroupState extends BaseState with _$CreateGroupState {
  const CreateGroupState._();

  const factory CreateGroupState.initial({
    required CreateGroupStateStore store,
  }) = Initial;

  const factory CreateGroupState.onCreateGroupSuccess({
    required CreateGroupStateStore store,
    String? iconUploadErrorMessage,
  }) = OnCreateGroupSuccess;

  const factory CreateGroupState.onGroupNameChange({
    required CreateGroupStateStore store,
  }) = OnGroupNameChange;

  const factory CreateGroupState.onGroupDescriptionChange({
    required CreateGroupStateStore store,
  }) = OnGroupDescriptionChange;

  const factory CreateGroupState.onGroupIconChange({
    required CreateGroupStateStore store,
  }) = OnGroupIconChange;

  const factory CreateGroupState.onFailure({
    required CreateGroupStateStore store,
    required Failure failure,
  }) = OnFailure;

  const factory CreateGroupState.changeLoaderState({
    required CreateGroupStateStore store,
  }) = ChangeLoaderState;

  @override
  BaseState getFailureState({required Failure failure}) =>
      CreateGroupState.onFailure(
        store: store.copyWith(loading: false),
        failure: failure,
      );

  @override
  BaseState getLoadingState({required bool loading}) =>
      CreateGroupState.changeLoaderState(
        store: store.copyWith(loading: loading),
      );
}

@freezed
class CreateGroupStateStore with _$CreateGroupStateStore {
  const CreateGroupStateStore({
    this.loading = false,
    this.groupName = '',
    this.groupDescription = '',
    this.groupIcon,
  });

  @override
  final bool loading;

  // TODO(Chaitanya): use value object
  @override
  final String groupName;

  // TODO(Chaitanya): use value object
  @override
  final String groupDescription;

  @override
  final File? groupIcon;
}
