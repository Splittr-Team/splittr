part of 'group_details_bloc.dart';

@freezed
class GroupDetailsEvent extends BaseEvent with _$GroupDetailsEvent {
  const GroupDetailsEvent._();

  const factory GroupDetailsEvent.started() = _Started;
}
