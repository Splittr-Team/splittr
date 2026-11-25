part of 'create_group_bloc.dart';

@freezed
class CreateGroupEvent extends BaseEvent with _$CreateGroupEvent {
  const CreateGroupEvent._();

  const factory CreateGroupEvent.groupNameChanged({required String groupName}) =
      _GroupNameChanged;

  const factory CreateGroupEvent.groupDescriptionChanged({
    required String groupDescription,
  }) = _GroupDescriptionChanged;

  const factory CreateGroupEvent.groupIconChanged({
    required File? groupIcon,
  }) = _GroupIconChanged;

  const factory CreateGroupEvent.createGroupButtonClicked() =
      _CreateGroupButtonClicked;
}
