import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/usecases/delete_group_usecase.dart';

part 'group_details_bloc.freezed.dart';
part 'group_details_event.dart';
part 'group_details_state.dart';

@injectable
final class GroupDetailsBloc
    extends BaseBloc<GroupDetailsEvent, GroupDetailsState, GroupDetailsParams> {
  GroupDetailsBloc(this._deleteGroupUseCase)
    : super(
        const GroupDetailsState.initial(
          store: GroupDetailsStateStore(),
        ),
      );

  final DeleteGroupUseCase _deleteGroupUseCase;

  //TODO(SKY): fix this
  late GroupDetailsParams _params;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_DeleteGroup>(_onDeleteGroup);
  }

  void _onStarted(_Started event, Emitter<GroupDetailsState> emit) {}

  FutureOr<void> _onDeleteGroup(
    _DeleteGroup event,
    Emitter<GroupDetailsState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _deleteGroupUseCase.call(
      DeleteGroupParams(groupId: _params.groupId),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) => emit(
        GroupDetailsState.onGroupDeleted(
          store: state.store.copyWith(loading: false),
        ),
      ),
    );
  }

  @override
  void started(GroupDetailsParams params) {
    _params = params;
    add(const GroupDetailsEvent.started());
  }

  void deleteGroup() {
    add(const GroupDetailsEvent.deleteGroup());
  }
}
