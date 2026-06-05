import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/auth/domain/usecases/signup_with_email_usecase.dart';

part 'signup_bloc.freezed.dart';
part 'signup_event.dart';
part 'signup_state.dart';

@injectable
class SignupBloc extends BaseBloc<SignupEvent, SignupState> {
  SignupBloc(this._signupWithEmailUseCase)
    : super(const SignupState.initial(store: SignupStateStore()));

  final SignupWithEmailUseCase _signupWithEmailUseCase;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  FutureOr<void> _onStarted(_Started event, Emitter<SignupState> emit) {}

  @override
  void started({Map<String, dynamic>? args}) {
    add(const SignupEvent.started());
  }
}
