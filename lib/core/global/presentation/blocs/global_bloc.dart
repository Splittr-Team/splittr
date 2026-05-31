import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/core/user/domain/models/user.dart';

part 'global_bloc.freezed.dart';
part 'global_event.dart';
part 'global_state.dart';

@injectable
final class GlobalBloc extends BaseBloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(const GlobalState.initial(store: GlobalStateStore()));

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_UserUpdated>(_onUserUpdated);
    on<_ThemeChanged>(_onThemeChanged);
  }

  void _onStarted(_, Emitter<GlobalState> emit) {}

  void _onUserUpdated(_UserUpdated event, Emitter<GlobalState> emit) {
    emit(
      GlobalState.updatedUser(store: state.store.copyWith(user: event.user)),
    );
  }

  void _onThemeChanged(_ThemeChanged event, Emitter<GlobalState> emit) {
    emit(
      GlobalState.themeUpdated(
        store: state.store.copyWith(themeMode: event.themeMode),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const GlobalEvent.started());
  }

  @override
  bool get isLoading => state.store.loading;

  void userUpdated(User user) {
    add(GlobalEvent.userUpdated(user: user));
  }

  void themeChanged(ThemeMode themeMode) {
    add(GlobalEvent.themeChanged(themeMode: themeMode));
  }
}
