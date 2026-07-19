import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/usecases/get_groups_usecase.dart';
import 'package:splittr/features/groups/domain/usecases/watch_groups_usecase.dart';

part 'groups_bloc.freezed.dart';
part 'groups_event.dart';
part 'groups_state.dart';

@injectable
final class GroupsBloc extends BaseBloc<GroupsEvent, GroupsState, NoParams> {
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
    on<_Started>(_onStarted, transformer: restartable());
    on<_GroupsUpdated>(_onGroupsUpdated);
    on<_GroupsFailed>(_onGroupsFailed);
    on<_FetchNextPage>(_onFetchNextPage, transformer: droppable());
  }

  void _listenToRepositoryStream() {
    _groupsSubscription = _watchGroupsUseCase.call(noParams).listen(
      (result) {
        result.fold(
          (failure) => groupsFailed(failure: failure),
          (groups) => groupsUpdated(groups: groups),
        );
      },
    );
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<GroupsState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _getGroupsUseCase.call(const GetGroupsParams());

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (paginatedList) => emit(
        GroupsState.onGroupsUpdate(
          store: state.store.copyWith(
            loading: false,
            hasMore: paginatedList.pagination.hasMore,
            nextCursor: paginatedList.pagination.nextCursor,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onFetchNextPage(
    _FetchNextPage event,
    Emitter<GroupsState> emit,
  ) async {
    if (state.store.loading || !state.store.hasMore) {
      return;
    }

    changeLoadingState(emit: emit, loading: true);

    final result = await _getGroupsUseCase.call(
      GetGroupsParams(cursor: state.store.nextCursor),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (paginatedList) => emit(
        GroupsState.onGroupsUpdate(
          store: state.store.copyWith(
            loading: false,
            hasMore: paginatedList.pagination.hasMore,
            nextCursor: paginatedList.pagination.nextCursor,
          ),
        ),
      ),
    );
  }

  void _onGroupsUpdated(
    _GroupsUpdated event,
    Emitter<GroupsState> emit,
  ) {
    emit(
      GroupsState.onGroupsUpdate(
        store: state.store.copyWith(groups: event.groups),
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
  void started(NoParams params) {
    add(const GroupsEvent.started());
  }

  void groupsFailed({required Failure failure}) {
    add(GroupsEvent.groupsFailed(failure: failure));
  }

  void groupsUpdated({required List<Group> groups}) {
    add(GroupsEvent.groupsUpdated(groups: groups));
  }

  void fetchNextPage() {
    add(const GroupsEvent.fetchNextPage());
  }

  @override
  Future<void> close() async {
    await _groupsSubscription?.cancel();
    return super.close();
  }
}
