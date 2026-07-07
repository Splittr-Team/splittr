import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/usecases/get_groups_usecase.dart';
import 'package:splittr/features/groups/domain/usecases/watch_groups_usecase.dart';

part 'groups_bloc.freezed.dart';
part 'groups_event.dart';
part 'groups_state.dart';

@injectable
final class GroupsBloc extends BaseBloc<GroupsEvent, GroupsState> {
  GroupsBloc(
    this._getGroupsUseCase,
    this._watchGroupsUseCase,
  ) : super(
        const GroupsState.initial(
          store: GroupsStateStore(groups: []),
        ),
      ) {
    _listenToRepositoryStream();
  }

  final GetGroupsUseCase _getGroupsUseCase;
  final WatchGroupsUseCase _watchGroupsUseCase;

  StreamSubscription<EitherFailure<List<Group>>>? _groupsSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_GroupsUpdated>(_onGroupsUpdated);
    on<_GroupsFailed>(_onGroupsFailed);
  }

  void _listenToRepositoryStream() {
    _groupsSubscription = _watchGroupsUseCase.call(noParams).listen(
      (result) {
        result.fold(
          (failure) {
            add(GroupsEvent.groupsFailed(failure: failure));
          },
          (groups) {
            add(GroupsEvent.groupsUpdated(groups: groups));
          },
        );
      },
    );
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<GroupsState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _getGroupsUseCase.call(noParams);

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (_) {
        changeLoadingState(emit: emit, loading: false);
      },
    );
  }

  void _onGroupsUpdated(
    _GroupsUpdated event,
    Emitter<GroupsState> emit,
  ) {
    emit(
      GroupsState.onGroupsUpdate(
        store: state.store.copyWith(loading: false, groups: event.groups),
      ),
    );
  }

  void _onGroupsFailed(
    _GroupsFailed event,
    Emitter<GroupsState> emit,
  ) {
    handleFailure(emit: emit, failure: event.failure);
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const GroupsEvent.started());
  }

  @override
  Future<void> close() async {
    await _groupsSubscription?.cancel();
    return super.close();
  }
}
