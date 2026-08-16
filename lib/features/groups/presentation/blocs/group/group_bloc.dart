import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';
import 'package:splittr/features/groups/domain/usecases/add_members_to_group_usecase.dart';
import 'package:splittr/features/groups/domain/usecases/delete_group_usecase.dart';
import 'package:splittr/features/groups/domain/usecases/leave_group_usecase.dart';

part 'group_bloc.freezed.dart';
part 'group_event.dart';
part 'group_state.dart';

@injectable
final class GroupBloc extends BaseBloc<GroupEvent, GroupState, String> {
  GroupBloc(
    this._deleteGroupUseCase,
    this._leaveGroupUseCase,
    this._addMembersToGroupUseCase,
    this._groupsRepository,
  ) : super(
        const GroupState.initial(
          store: GroupStateStore(),
        ),
      );

  final DeleteGroupUseCase _deleteGroupUseCase;
  final LeaveGroupUseCase _leaveGroupUseCase;
  final AddMembersToGroupUseCase _addMembersToGroupUseCase;
  final GroupsRepository _groupsRepository;

  late String _groupId;
  StreamSubscription<EitherFailure<List<Group>>>? _groupsSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted, transformer: restartable());
    on<_DeleteGroup>(_onDeleteGroup);
    on<_LeaveGroup>(_onLeaveGroup);
    on<_AddMembers>(_onAddMembers);
    on<_GroupUpdated>(_onGroupUpdated);
    on<_LoadFailed>(_onLoadFailed);
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<GroupState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);
    await _groupsSubscription?.cancel();
    _groupsSubscription = _groupsRepository.watchGroups.listen(
      (result) {
        result.fold(
          (failure) => add(GroupEvent.loadFailed(failure: failure)),
          (groups) {
            final group = groups.where((g) => g.id == _groupId).firstOrNull;
            if (group != null) {
              add(GroupEvent.groupUpdated(group: group));
            } else {
              unawaited(
                _groupsRepository.getGroups().then((remoteResult) {
                  remoteResult.fold(
                    (failure) => add(GroupEvent.loadFailed(failure: failure)),
                    (paginatedList) {
                      final remoteGroup = paginatedList.items
                          .where((g) => g.id == _groupId)
                          .firstOrNull;
                      if (remoteGroup == null) {
                        add(
                          const GroupEvent.loadFailed(
                            failure: ServerFailure(message: 'Group not found'),
                          ),
                        );
                      }
                    },
                  );
                }),
              );
            }
          },
        );
      },
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
      DeleteGroupParams(groupId: _groupId),
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

  FutureOr<void> _onLeaveGroup(
    _LeaveGroup event,
    Emitter<GroupState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _leaveGroupUseCase.call(
      LeaveGroupParams(groupId: _groupId, userId: event.userId),
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

    final result = await _addMembersToGroupUseCase.call(
      AddMembersToGroupParams(groupId: _groupId, userIds: event.userIds),
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
    _groupId = groupId;
    add(const GroupEvent.started());
  }

  void deleteGroup(String groupId) {
    add(const GroupEvent.deleteGroup());
  }

  void leaveGroup(String userId) {
    add(GroupEvent.leaveGroup(userId: userId));
  }

  void addMembers(List<String> userIds) {
    add(GroupEvent.addMembers(userIds: userIds));
  }

  @override
  Future<void> close() async {
    await _groupsSubscription?.cancel();
    return super.close();
  }
}
