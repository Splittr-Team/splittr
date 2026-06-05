import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/auth/domain/usecases/login_with_email_usecase.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc(this._loginWithEmailUseCase)
    : super(const LoginState.initial(store: LoginStateStore()));

  final LoginWithEmailUseCase _loginWithEmailUseCase;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  FutureOr<void> _onStarted(_Started event, Emitter<LoginState> emit) {}

  @override
  void started({Map<String, dynamic>? args}) {
    add(const LoginEvent.started());
  }
}
