import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';

part 'dashboard_bloc.freezed.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
final class DashboardBloc extends BaseBloc<DashboardEvent, DashboardState> {
  DashboardBloc()
    : super(const DashboardState.initial(store: DashboardStateStore()));

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_IndexChanged>(_onIndexChanged);
  }

  void _onStarted(_Started event, Emitter<DashboardState> emit) {}

  FutureOr<void> _onIndexChanged(
    _IndexChanged event,
    Emitter<DashboardState> emit,
  ) {
    emit(
      DashboardState.onIndexChanged(
        store: state.store.copyWith(selectedIndex: event.index),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const DashboardEvent.started());
  }

  void indexChanged(int index) {
    add(DashboardEvent.indexChanged(index: index));
  }
}
