import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/usecases/create_group_usecase.dart';
import 'package:splittr/features/groups/domain/usecases/upload_group_icon_usecase.dart';

part 'create_group_bloc.freezed.dart';
part 'create_group_event.dart';
part 'create_group_state.dart';

@injectable
final class CreateGroupBloc
    extends BaseBloc<CreateGroupEvent, CreateGroupState, NoParams> {
  CreateGroupBloc(
    this._createGroupUseCase,
    this._uploadGroupIconUseCase,
  ) : super(const CreateGroupState.initial(store: CreateGroupStateStore()));

  final CreateGroupUseCase _createGroupUseCase;
  final UploadGroupIconUseCase _uploadGroupIconUseCase;

  @override
  void handleEvents() {
    on<_GroupNameChanged>(_onGroupNameChanged);
    on<_GroupDescriptionChanged>(_onGroupDescriptionChanged);
    on<_GroupIconChanged>(_onGroupIconChanged);
    on<_CreateGroupButtonClicked>(_onCreateGroupButtonClicked);
  }

  @override
  void started(NoParams params) {}

  FutureOr<void> _onGroupNameChanged(
    _GroupNameChanged event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(
      CreateGroupState.onGroupNameChange(
        store: state.store.copyWith(groupName: event.groupName),
      ),
    );
  }

  FutureOr<void> _onGroupDescriptionChanged(
    _GroupDescriptionChanged event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(
      CreateGroupState.onGroupDescriptionChange(
        store: state.store.copyWith(groupDescription: event.groupDescription),
      ),
    );
  }

  FutureOr<void> _onGroupIconChanged(
    _GroupIconChanged event,
    Emitter<CreateGroupState> emit,
  ) {
    emit(
      CreateGroupState.onGroupIconChange(
        store: state.store.copyWith(groupIcon: event.groupIcon),
      ),
    );
  }

  FutureOr<void> _onCreateGroupButtonClicked(
    _CreateGroupButtonClicked event,
    Emitter<CreateGroupState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _createGroupUseCase.call(
      CreateGroupParams(
        name: state.store.groupName,
        description: state.store.groupDescription,
      ),
    );

    await result.fold(
      (failure) async => handleFailure(emit: emit, failure: failure),
      (group) async {
        String? iconUploadErrorMessage;
        final iconFile = state.store.groupIcon;
        final groupId = group.id;
        if (iconFile != null && groupId != null) {
          final iconResult = await _uploadGroupIconUseCase.call(
            UploadGroupIconParams(
              groupId: groupId,
              file: iconFile,
            ),
          );
          iconResult.fold(
            (failure) => iconUploadErrorMessage = failure.message,
            (_) {},
          );
        }

        emit(
          CreateGroupState.onCreateGroupSuccess(
            store: state.store.copyWith(loading: false),
            iconUploadErrorMessage: iconUploadErrorMessage,
          ),
        );
      },
    );
  }

  void groupNameChanged({required String groupName}) {
    add(CreateGroupEvent.groupNameChanged(groupName: groupName));
  }

  void groupDescriptionChanged({required String groupDescription}) {
    add(
      CreateGroupEvent.groupDescriptionChanged(
        groupDescription: groupDescription,
      ),
    );
  }

  void groupIconChanged({required File? groupIcon}) {
    add(CreateGroupEvent.groupIconChanged(groupIcon: groupIcon));
  }

  void createGroupButtonClicked() {
    add(const CreateGroupEvent.createGroupButtonClicked());
  }
}
