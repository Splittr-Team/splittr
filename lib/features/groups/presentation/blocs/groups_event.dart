part of 'groups_bloc.dart';

@freezed
class GroupsEvent extends BaseEvent with _$GroupsEvent {
  const GroupsEvent._();

  const factory GroupsEvent.started() = _Started;

  const factory GroupsEvent.groupsFailed({required Failure failure}) =
      _GroupsFailed;

  const factory GroupsEvent.groupsUpdated({required List<Group> groups}) =
      _GroupsUpdated;
}
