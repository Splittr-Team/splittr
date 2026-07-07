import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/entities/groups.dart';
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
          store: GroupsStateStore(),
        ),
      );

  final GetGroupsUseCase _getGroupsUseCase;
  final WatchGroupsUseCase _watchGroupsUseCase;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<GroupsState> emit,
  ) async {
    // 1. Emit the loading state
    emit(
      GroupsState.changeLoaderState(store: state.store.copyWith(loading: true)),
    );

    // 2. Trigger the API fetch via UseCase
    // Assuming 'noParams' is defined in your sky_architecture package.
    // If not, replace with 'const NoParams()'.
    final result = await _getGroupsUseCase.call(noParams);

    final hasError = result.fold(
      (failure) {
        emit(
          GroupsState.onFailure(
            store: state.store.copyWith(loading: false),
            failure: failure,
          ),
        );
        return true;
      },
      (_) => false,
    );

    // If API call fails, stop and show the error state.
    if (hasError) return;

    // 3. Listen to the stream using the Watch UseCase
    await emit.forEach<List<Group>>(
      _watchGroupsUseCase.call(),
      onData: (groups) => GroupsState.loaded(
        store: state.store.copyWith(loading: false),
        groups: groups,
      ),
    );
  }

  @override
  void started({
    Map<String, dynamic>? args,
  }) {
    add(const GroupsEvent.started());
  }
}
