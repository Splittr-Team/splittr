import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/core/auth/domain/repositories/i_auth_repository.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@injectable
final class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository)
    : super(const LoginState.initial(store: LoginStateStore()));
  final IAuthRepository _authRepository;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_PhoneNumberChanged>(_onPhoneNumberChanged);
    on<_SendOtpClicked>(_onSendOtpClicked);
    on<_VerificationFailed>(_onVerificationFailed);
    on<_OtpCreated>(_onOtpCreated);
  }

  void _onStarted(_Started event, Emitter<LoginState> emit) {}

  void _onPhoneNumberChanged(
    _PhoneNumberChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      LoginState.phoneNumberChange(
        store: state.store.copyWith(phoneNumber: event.phoneNumber),
      ),
    );
  }

  Future<void> _onSendOtpClicked(_, Emitter<LoginState> emit) async {
    final phoneNumber = state.store.phoneNumber;

    if (phoneNumber == null || phoneNumber.length != 10) {
      return;
    }

    changeLoadingState(emit: emit, loading: true);

    await _authRepository.sendOtp(
      phoneNumber: phoneNumber,
      onOtpSent: otpCreated,
      onVerificationFailed: verificationFailed,
      forceResendingToken: state.store.forceResendingToken,
    );
  }

  void _onVerificationFailed(
    _VerificationFailed event,
    Emitter<LoginState> emit,
  ) {
    handleFailure(
      emit: emit,
      failure: ServerFailure(message: event.errorMessage),
    );
  }

  void _onOtpCreated(_OtpCreated event, Emitter<LoginState> emit) {
    emit(
      LoginState.otpSent(
        store: state.store.copyWith(
          loading: false,
          verificationId: event.verificationId,
          forceResendingToken: event.forceResendingToken,
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const LoginEvent.started());
  }

  void phoneNumberChanged(String phoneNumber) {
    add(LoginEvent.phoneNumberChanged(phoneNumber: phoneNumber));
  }

  void sendOtpClicked() {
    add(const LoginEvent.sendOtpClicked());
  }

  void otpCreated(String verificationId, int? forceResendingToken) {
    add(
      LoginEvent.otpCreated(
        verificationId: verificationId,
        forceResendingToken: forceResendingToken,
      ),
    );
  }

  void verificationFailed(String errorMessage) {
    add(LoginEvent.verificationFailed(errorMessage: errorMessage));
  }
}
