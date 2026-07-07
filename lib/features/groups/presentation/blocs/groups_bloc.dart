import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/entities/groups.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

part 'groups_bloc.freezed.dart';
part 'groups_event.dart';
part 'groups_state.dart';

@injectable
final class GroupsBloc extends BaseBloc<GroupsEvent, GroupsState> {
  GroupsBloc(this._repository)
      : super(
          const GroupsState.initial(
            store: GroupsStateStore(),
          ),
        );

  final GroupsRepository _repository;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<GroupsState> emit,
  ) async {
    // 1. Emit the loading state
    emit(GroupsState.loading(store: state.store.copyWith(loading: true)));

    // 2. Trigger the API fetch
    final result = await _repository.fetchGroups();

    final hasError = result.fold(
      (failure) {
        emit(
          GroupsState.error(
            store: state.store.copyWith(loading: false),
            message: failure.message,
          ),
        );
        return true;
      },
      (_) => false,
    );

    // If API call fails, stop and show the error state.
    if (hasError) return;

    // 3. Immediately use emit.forEach on repository stream to handle success/live data.
    await emit.forEach<List<Groups>>(
      _repository.watchGroups,
      onData: (groups) => GroupsState.loaded(
        store: state.store.copyWith(loading: false),
        groups: groups,
      ),
      onError: (error, stackTrace) => GroupsState.error(
        store: state.store.copyWith(loading: false),
        message: error.toString(),
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
