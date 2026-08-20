import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/usecases/add_members_to_group_usecase.dart';
import 'package:splittr/features/groups/domain/usecases/delete_group_usecase.dart';
import 'package:splittr/features/groups/domain/usecases/get_group_by_id_usecase.dart';
import 'package:splittr/features/groups/domain/usecases/leave_group_usecase.dart';
import 'package:splittr/features/groups/domain/usecases/watch_group_by_id_usecase.dart';

part 'group_bloc.freezed.dart';
part 'group_event.dart';
part 'group_state.dart';

@injectable
final class GroupBloc extends BaseBloc<GroupEvent, GroupState, String> {
  GroupBloc(
    this._deleteGroupUseCase,
    this._leaveOrRemoveGroupUseCase,
    this._addMembersUseCase,
    this._watchGroupByIdUseCase,
    this._getGroupByIdUseCase,
  ) : super(
        const GroupState.initial(
          store: GroupStateStore(),
        ),
      );

  final DeleteGroupUseCase _deleteGroupUseCase;
  final LeaveOrRemoveGroupUseCase _leaveOrRemoveGroupUseCase;
  final AddMembersUseCase _addMembersUseCase;
  final WatchGroupByIdUseCase _watchGroupByIdUseCase;
  final GetGroupByIdUseCase _getGroupByIdUseCase;

  StreamSubscription<EitherFailure<Group>>? _groupSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted, transformer: restartable());
    on<_DeleteGroup>(_onDeleteGroup);
    on<_LeaveOrRemoveGroup>(_onLeaveOrRemoveGroup);
    on<_AddMembers>(_onAddMembers);
    on<_GroupUpdated>(_onGroupUpdated);
    on<_LoadFailed>(_onLoadFailed);
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<GroupState> emit,
  ) async {
    emit(
      GroupState.initial(
        store: state.store.copyWith(
          loading: true,
          groupId: event.groupId,
        ),
      ),
    );
    await _groupSubscription?.cancel();
    _groupSubscription = _watchGroupByIdUseCase.call(event.groupId).listen(
      (result) {
        result.fold(
          (failure) => loadFailed(failure: failure),
          (group) => groupUpdated(group: group),
        );
      },
    );

    final result = await _getGroupByIdUseCase.call(event.groupId);

    result.fold(
      (failure) => loadFailed(failure: failure),
      (_) => emit(
        GroupState.initial(
          store: state.store.copyWith(
            loading: false,
          ),
        ),
      ),
    );
  }

  void _onGroupUpdated(
    _GroupUpdated event,
    Emitter<GroupState> emit,
  ) {
    emit(
      GroupState.initial(
        store: state.store.copyWith(
          loading: false,
          group: event.group,
        ),
      ),
    );
  }

  void _onLoadFailed(
    _LoadFailed event,
    Emitter<GroupState> emit,
  ) {
    handleFailure(emit: emit, failure: event.failure);
  }

  FutureOr<void> _onDeleteGroup(
    _DeleteGroup event,
    Emitter<GroupState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _deleteGroupUseCase.call(
      DeleteGroupParams(groupId: state.store.groupId),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) => emit(
        GroupState.onGroupDeleted(
          store: state.store.copyWith(loading: false),
        ),
      ),
    );
  }

  FutureOr<void> _onLeaveOrRemoveGroup(
    _LeaveOrRemoveGroup event,
    Emitter<GroupState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _leaveOrRemoveGroupUseCase.call(
      LeaveOrRemoveGroupParams(
        groupId: state.store.groupId,
        userId: event.userId,
      ),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) => emit(
        GroupState.onGroupLeft(
          store: state.store.copyWith(loading: false),
        ),
      ),
    );
  }

  FutureOr<void> _onAddMembers(
    _AddMembers event,
    Emitter<GroupState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _addMembersUseCase.call(
      AddMembersParams(groupId: state.store.groupId, userIds: event.userIds),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) => emit(
        GroupState.onMembersAdded(
          store: state.store.copyWith(loading: false),
        ),
      ),
    );
  }

  @override
  void started(String groupId) {
    add(GroupEvent.started(groupId: groupId));
  }

  void deleteGroup({required String groupId}) {
    add(const GroupEvent.deleteGroup());
  }

  void leaveOrRemoveGroup({required String userId}) {
    add(GroupEvent.leaveOrRemoveGroup(userId: userId));
  }

  void addMembers({required List<String> userIds}) {
    add(GroupEvent.addMembers(userIds: userIds));
  }

  void groupUpdated({required Group group}) {
    add(GroupEvent.groupUpdated(group: group));
  }

  void loadFailed({required Failure failure}) {
    add(GroupEvent.loadFailed(failure: failure));
  }

  @override
  Future<void> close() async {
    await _groupSubscription?.cancel();
    return super.close();
  }
}
