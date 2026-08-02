import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';
import 'package:splittr/features/activities/domain/usecases/get_activities_usecase.dart';
import 'package:splittr/features/activities/domain/usecases/watch_activities_usecase.dart';

part 'activities_bloc.freezed.dart';
part 'activities_event.dart';
part 'activities_state.dart';

@injectable
final class ActivitiesBloc
    extends BaseBloc<ActivitiesEvent, ActivitiesState, NoParams> {
  ActivitiesBloc(
    this._getActivitiesUseCase,
    this._watchActivitiesUseCase,
  ) : super(
        const ActivitiesState.initial(
          store: ActivitiesStateStore(activities: []),
        ),
      ) {
    _listenToRepositoryStream();
  }

  final GetActivitiesUseCase _getActivitiesUseCase;
  final WatchActivitiesUseCase _watchActivitiesUseCase;

  StreamSubscription<EitherFailure<List<Activity>>>? _activitiesSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted, transformer: restartable());
    on<_ActivitiesUpdated>(_onActivitiesUpdated);
    on<_ActivitiesFailed>(_onActivitiesFailed);
    on<_FetchNextPage>(_onFetchNextPage, transformer: droppable());
  }

  void _listenToRepositoryStream() {
    _activitiesSubscription = _watchActivitiesUseCase
        .call(const WatchActivitiesParams())
        .listen(
          (result) {
            result.fold(
              (failure) => activitiesFailed(failure: failure),
              (activities) => activitiesUpdated(activities: activities),
            );
          },
        );
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<ActivitiesState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _getActivitiesUseCase.call(
      const GetActivitiesParams(),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (paginatedList) => emit(
        ActivitiesState.onActivitiesUpdate(
          store: state.store.copyWith(
            loading: false,
            hasMore: paginatedList.pagination.hasMore,
            nextCursor: paginatedList.pagination.nextCursor,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onFetchNextPage(
    _FetchNextPage event,
    Emitter<ActivitiesState> emit,
  ) async {
    if (state.store.loading || !state.store.hasMore) {
      return;
    }

    changeLoadingState(emit: emit, loading: true);

    final result = await _getActivitiesUseCase.call(
      GetActivitiesParams(cursor: state.store.nextCursor),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (paginatedList) => emit(
        ActivitiesState.onActivitiesUpdate(
          store: state.store.copyWith(
            loading: false,
            hasMore: paginatedList.pagination.hasMore,
            nextCursor: paginatedList.pagination.nextCursor,
          ),
        ),
      ),
    );
  }

  void _onActivitiesUpdated(
    _ActivitiesUpdated event,
    Emitter<ActivitiesState> emit,
  ) {
    emit(
      ActivitiesState.onActivitiesUpdate(
        store: state.store.copyWith(activities: event.activities),
      ),
    );
  }

  void _onActivitiesFailed(
    _ActivitiesFailed event,
    Emitter<ActivitiesState> emit,
  ) {
    handleFailure(emit: emit, failure: event.failure);
  }

  @override
  void started(NoParams params) {
    add(const ActivitiesEvent.started());
  }

  void activitiesFailed({required Failure failure}) {
    add(ActivitiesEvent.activitiesFailed(failure: failure));
  }

  void activitiesUpdated({required List<Activity> activities}) {
    add(ActivitiesEvent.activitiesUpdated(activities: activities));
  }

  void fetchNextPage() {
    add(const ActivitiesEvent.fetchNextPage());
  }

  @override
  Future<void> close() async {
    await _activitiesSubscription?.cancel();
    return super.close();
  }
}
