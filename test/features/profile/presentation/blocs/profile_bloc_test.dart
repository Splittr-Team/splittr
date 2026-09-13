import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';
import 'package:splittr/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:splittr/features/auth/domain/usecases/watch_auth_state_usecase.dart';
import 'package:splittr/features/profile/presentation/blocs/profile_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late WatchAuthStateUseCase watchAuthStateUseCase;
  late DeleteAccountUseCase deleteAccountUseCase;
  late StreamController<Option<User>> authStreamController;
  late ProfileBloc bloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    watchAuthStateUseCase = WatchAuthStateUseCase(mockAuthRepository);
    deleteAccountUseCase = DeleteAccountUseCase(mockAuthRepository);
    authStreamController = StreamController<Option<User>>.broadcast();

    when(() => mockAuthRepository.watchAuthState)
        .thenAnswer((_) => authStreamController.stream);

    bloc = ProfileBloc(
      watchAuthStateUseCase,
      deleteAccountUseCase,
    );
  });

  tearDown(() async {
    await authStreamController.close();
    await bloc.close();
  });

  group('ProfileBloc', () {
    test('initial state has default values', () {
      expect(bloc.state.store.loading, false);
      expect(bloc.state.store.selectedCurrency, 'INR');
      expect(bloc.state.store.isDarkMode, true);
    });

    test('deleteAccountRequested emits OnAccountDeleted on success', () async {
      when(() => mockAuthRepository.deleteAccount())
          .thenAnswer((_) async => const Right(unit));

      unawaited(
        expectLater(
          bloc.stream,
          emitsInOrder([
            isA<ChangeLoaderState>().having(
              (s) => s.store.loading,
              'loading',
              true,
            ),
            isA<ChangeLoaderState>().having(
              (s) => s.store.loading,
              'loading',
              false,
            ),
            isA<OnAccountDeleted>(),
          ]),
        ),
      );

      bloc.deleteAccountRequested();
    });

    test(
      'deleteAccountRequested emits OnDeleteAccountFailure on failure',
      () async {
        const failure = ServerFailure(
          message: 'Cannot delete account with outstanding balances.',
        );
        when(() => mockAuthRepository.deleteAccount())
            .thenAnswer((_) async => const Left(failure));

        unawaited(
          expectLater(
            bloc.stream,
            emitsInOrder([
              isA<ChangeLoaderState>().having(
                (s) => s.store.loading,
                'loading',
                true,
              ),
              isA<ChangeLoaderState>().having(
                (s) => s.store.loading,
                'loading',
                false,
              ),
              isA<OnDeleteAccountFailure>().having(
                (s) => s.failure.message,
                'failure message',
                contains('outstanding balances'),
              ),
            ]),
          ),
        );

        bloc.deleteAccountRequested();
      },
    );
  });
}
