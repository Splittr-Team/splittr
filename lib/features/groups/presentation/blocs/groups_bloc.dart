import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';

part 'groups_bloc.freezed.dart';
part 'groups_event.dart';
part 'groups_state.dart';

@injectable
final class GroupsBloc extends BaseBloc<GroupsEvent, GroupsState> {
  GroupsBloc() : super(const GroupsState.initial(store: GroupsStateStore()));

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  void _onStarted(_Started event, Emitter<GroupsState> emit) {}

  @override
  void started({Map<String, dynamic>? args}) {
    add(const GroupsEvent.started());
  }
}
