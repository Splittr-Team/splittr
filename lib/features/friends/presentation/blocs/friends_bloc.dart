import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/domain/usecases/get_friends_usecase.dart';
import 'package:splittr/features/friends/domain/usecases/watch_friends_usecase.dart';

part 'friends_bloc.freezed.dart';
part 'friends_event.dart';
part 'friends_state.dart';

@injectable
class FriendsBloc extends BaseBloc<FriendsEvent, FriendsState, NoParams> {
  FriendsBloc(
    this._getFriendsUseCase,
    this._watchFriendsUseCase,
  ) : super(
        const FriendsState.initial(
          store: FriendsStateStore(friends: []),
        ),
      ) {
    _listenToRepositoryStream();
  }

  final GetFriendsUseCase _getFriendsUseCase;
  final WatchFriendsUseCase _watchFriendsUseCase;

  StreamSubscription<EitherFailure<List<Friend>>>? _friendsSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted, transformer: restartable());
    on<_FriendsUpdated>(_onFriendsUpdated);
    on<_FriendsFailed>(_onFriendsFailed);
    on<_FetchNextPage>(_onFetchNextPage, transformer: droppable());
  }

  void _listenToRepositoryStream() {
    _friendsSubscription = _watchFriendsUseCase.call(noParams).listen(
      (result) {
        result.fold(
          (failure) => friendsFailed(failure: failure),
          (friends) => friendsUpdated(friends: friends),
        );
      },
    );
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<FriendsState> emit,
  ) async {
    changeLoadingState(emit: emit, loading: true);

    final result = await _getFriendsUseCase.call(const GetFriendsParams());

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (paginatedList) => emit(
        FriendsState.onFriendsUpdated(
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
    Emitter<FriendsState> emit,
  ) async {
    if (state.store.loading || !state.store.hasMore) {
      return;
    }

    changeLoadingState(emit: emit, loading: true);

    final result = await _getFriendsUseCase.call(
      GetFriendsParams(cursor: state.store.nextCursor),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (paginatedList) => emit(
        FriendsState.onFriendsUpdated(
          store: state.store.copyWith(
            loading: false,
            hasMore: paginatedList.pagination.hasMore,
            nextCursor: paginatedList.pagination.nextCursor,
          ),
        ),
      ),
    );
  }

  void _onFriendsUpdated(
    _FriendsUpdated event,
    Emitter<FriendsState> emit,
  ) {
    emit(
      FriendsState.onFriendsUpdated(
        store: state.store.copyWith(friends: event.friends),
      ),
    );
  }

  void _onFriendsFailed(
    _FriendsFailed event,
    Emitter<FriendsState> emit,
  ) {
    handleFailure(emit: emit, failure: event.failure);
  }

  @override
  void started(NoParams params) {
    add(const FriendsEvent.started());
  }

  void friendsFailed({required Failure failure}) {
    add(FriendsEvent.friendsFailed(failure: failure));
  }

  void friendsUpdated({required List<Friend> friends}) {
    add(FriendsEvent.friendsUpdated(friends: friends));
  }

  void fetchNextPage() {
    add(const FriendsEvent.fetchNextPage());
  }

  @override
  Future<void> close() async {
    await _friendsSubscription?.cancel();
    return super.close();
  }
}
