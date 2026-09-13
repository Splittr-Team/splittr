import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/usecases/watch_auth_state_usecase.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

@injectable
final class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState, NoParams> {
  ProfileBloc(
    this._watchAuthStateUseCase,
  ) : super(
        const ProfileState.initial(
          store: ProfileStateStore(),
        ),
      );

  final WatchAuthStateUseCase _watchAuthStateUseCase;
  StreamSubscription<Option<User>>? _userSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_UserUpdated>(_onUserUpdated);
    on<_CurrencyChanged>(_onCurrencyChanged);
    on<_ThemeModeToggled>(_onThemeModeToggled);
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<ProfileState> emit,
  ) async {
    await _userSubscription?.cancel();
    _userSubscription = _watchAuthStateUseCase.call(noParams).listen(
      (userOption) {
        userOption.fold(
          () => userUpdated(user: null),
          (user) => userUpdated(user: user),
        );
      },
    );
  }

  void _onUserUpdated(
    _UserUpdated event,
    Emitter<ProfileState> emit,
  ) {
    final user = event.user;
    emit(
      ProfileState.onProfileLoaded(
        store: state.store.copyWith(
          user: user,
          selectedCurrency:
              user?.defaultCurrency ?? state.store.selectedCurrency,
        ),
      ),
    );
  }

  void _onCurrencyChanged(
    _CurrencyChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      ProfileState.onProfileLoaded(
        store: state.store.copyWith(
          selectedCurrency: event.currency,
          user: state.store.user?.copyWith(defaultCurrency: event.currency),
        ),
      ),
    );
  }

  void _onThemeModeToggled(
    _ThemeModeToggled event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      ProfileState.onProfileLoaded(
        store: state.store.copyWith(
          isDarkMode: event.isDarkMode,
        ),
      ),
    );
  }

  @override
  void started(NoParams params) {
    add(const ProfileEvent.started());
  }

  void userUpdated({required User? user}) {
    add(ProfileEvent.userUpdated(user: user));
  }

  void currencyChanged({required String currency}) {
    add(ProfileEvent.currencyChanged(currency: currency));
  }

  void themeModeToggled({required bool isDarkMode}) {
    add(ProfileEvent.themeModeToggled(isDarkMode: isDarkMode));
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    return super.close();
  }
}
