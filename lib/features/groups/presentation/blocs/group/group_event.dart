part of 'group_bloc.dart';

@freezed
class GroupEvent extends BaseEvent with _$GroupEvent {
  const GroupEvent._();

  const factory GroupEvent.started() = _Started;

  const factory GroupEvent.deleteGroup() = _DeleteGroup;

  const factory GroupEvent.leaveGroup({
    required String userId,
  }) = _LeaveGroup;

  const factory GroupEvent.addMembers({
    required List<String> userIds,
  }) = _AddMembers;

  const factory GroupEvent.groupUpdated({
    required Group group,
  }) = _GroupUpdated;

  const factory GroupEvent.loadFailed({
    required Failure failure,
  }) = _LoadFailed;
}
