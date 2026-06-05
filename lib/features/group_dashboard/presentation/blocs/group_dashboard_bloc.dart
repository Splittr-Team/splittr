import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';

part 'group_dashboard_bloc.freezed.dart';
part 'group_dashboard_event.dart';
part 'group_dashboard_state.dart';

@injectable
final class GroupDashboardBloc
    extends BaseBloc<GroupDashboardEvent, GroupDashboardState> {
  GroupDashboardBloc()
    : super(
        const GroupDashboardState.initial(store: GroupDashboardStateStore()),
      );

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  void _onStarted(_Started event, Emitter<GroupDashboardState> emit) {}

  @override
  void started({Map<String, dynamic>? args}) {
    add(const GroupDashboardEvent.started());
  }
}
