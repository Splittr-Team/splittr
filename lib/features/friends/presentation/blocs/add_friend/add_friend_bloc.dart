import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/domain/usecases/add_friend_usecase.dart';

part 'add_friend_bloc.freezed.dart';
part 'add_friend_event.dart';
part 'add_friend_state.dart';

@injectable
final class AddFriendBloc
    extends BaseBloc<AddFriendEvent, AddFriendState, NoParams> {
  AddFriendBloc(this._addFriendUseCase)
    : super(const AddFriendState.initial(store: AddFriendStateStore()));

  final AddFriendUseCase _addFriendUseCase;

  @override
  void handleEvents() {
    on<_EmailOrPhoneChanged>(_onEmailOrPhoneChanged);
    on<_SubmitButtonClicked>(_onSubmitButtonClicked);
  }

  @override
  void started(NoParams params) {}

  FutureOr<void> _onEmailOrPhoneChanged(
    _EmailOrPhoneChanged event,
    Emitter<AddFriendState> emit,
  ) {
    emit(
      AddFriendState.onEmailOrPhoneChange(
        store: state.store.copyWith(emailOrPhone: event.emailOrPhone),
      ),
    );
  }

  FutureOr<void> _onSubmitButtonClicked(
    _SubmitButtonClicked event,
    Emitter<AddFriendState> emit,
  ) async {
    final value = state.store.emailOrPhone.trim();
    if (value.isEmpty) {
      return;
    }

    changeLoadingState(emit: emit, loading: true);

    final isEmail = value.contains('@');
    final friendEmail = isEmail ? value : null;
    final friendPhone = isEmail ? null : value;

    final result = await _addFriendUseCase.call(
      AddFriendParams(
        friendEmail: friendEmail,
        friendPhone: friendPhone,
      ),
    );

    result.fold(
      (failure) => handleFailure(emit: emit, failure: failure),
      (friend) => emit(
        AddFriendState.onAddFriendSuccess(store: state.store, friend: friend),
      ),
    );
  }

  void emailOrPhoneChanged({required String emailOrPhone}) {
    add(AddFriendEvent.emailOrPhoneChanged(emailOrPhone: emailOrPhone));
  }

  void submitButtonClicked() {
    add(const AddFriendEvent.submitButtonClicked());
  }
}
