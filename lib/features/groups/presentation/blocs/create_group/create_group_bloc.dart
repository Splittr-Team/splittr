import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/usecases/create_group_usecase.dart';

part 'create_group_bloc.freezed.dart';
part 'create_group_event.dart';
part 'create_group_state.dart';

@injectable
final class CreateGroupBloc
    extends BaseBloc<CreateGroupEvent, CreateGroupState> {
  CreateGroupBloc(this._createGroupUseCase)
    : super(const CreateGroupState.initial(store: CreateGroupStateStore()));

  final CreateGroupUseCase _createGroupUseCase;

  @override
  void handleEvents() {
    on<_GroupNameChanged>(_onGroupNameChanged);
    on<_GroupDescriptionChanged>(_onGroupDescriptionChanged);
    on<_CreateGroupButtonClicked>(_onCreateGroupButtonClicked);
  }

  @override
  void started({Map<String, dynamic>? args}) {}

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

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) => emit(CreateGroupState.onCreateGroupSuccess(store: state.store)),
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

  void createGroupButtonClicked() {
    add(const CreateGroupEvent.createGroupButtonClicked());
  }
}
