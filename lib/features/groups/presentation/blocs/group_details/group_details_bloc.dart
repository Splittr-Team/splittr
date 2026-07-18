import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';

part 'group_details_bloc.freezed.dart';
part 'group_details_event.dart';
part 'group_details_state.dart';

@injectable
final class GroupDetailsBloc
    extends BaseBloc<GroupDetailsEvent, GroupDetailsState> {
  GroupDetailsBloc()
    : super(
        const GroupDetailsState.initial(
          store: GroupDetailsStateStore(),
        ),
      );

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  void _onStarted(_Started event, Emitter<GroupDetailsState> emit) {}

  @override
  void started({Map<String, dynamic>? args}) {
    add(const GroupDetailsEvent.started());
  }
}
