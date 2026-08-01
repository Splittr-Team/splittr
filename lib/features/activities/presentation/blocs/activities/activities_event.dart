part of 'activities_bloc.dart';

@freezed
class ActivitiesEvent extends BaseEvent with _$ActivitiesEvent {
  const ActivitiesEvent._();

  const factory ActivitiesEvent.started() = _Started;

  const factory ActivitiesEvent.activitiesFailed({
    required Failure failure,
  }) = _ActivitiesFailed;

  const factory ActivitiesEvent.activitiesUpdated({
    required List<Activity> activities,
  }) = _ActivitiesUpdated;

  const factory ActivitiesEvent.fetchNextPage() = _FetchNextPage;
}
