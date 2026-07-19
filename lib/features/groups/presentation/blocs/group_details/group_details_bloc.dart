import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';

part 'group_details_bloc.freezed.dart';
part 'group_details_event.dart';
part 'group_details_state.dart';

@injectable
final class GroupDetailsBloc
    extends BaseBloc<GroupDetailsEvent, GroupDetailsState, GroupDetailsParams> {
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
  void started(GroupDetailsParams params) {
    add(const GroupDetailsEvent.started());
  }
}
