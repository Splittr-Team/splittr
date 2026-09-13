import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:splittr/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:splittr/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockApiCallHandler extends Mock implements ApiCallHandler {}

class MockIsar extends Mock implements Isar {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockApiCallHandler mockApiCallHandler;
  late MockIsar mockIsar;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockApiCallHandler = MockApiCallHandler();
    mockIsar = MockIsar();
    repository = AuthRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockApiCallHandler,
      mockIsar,
    );
  });

  group('logout', () {
    test('clears Isar cache when remote logout succeeds', () async {
      when(() => mockRemoteDataSource.logout()).thenAnswer((_) async {});
      when(() => mockIsar.writeTxn<void>(any())).thenAnswer((invocation) async {
        final callback =
            invocation.positionalArguments[0] as Future<void> Function();
        await callback();
      });
      when(() => mockIsar.clear()).thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.logout()).called(1);
      verify(() => mockIsar.clear()).called(1);
    });

    test('does not clear Isar cache when remote logout fails', () async {
      when(() => mockRemoteDataSource.logout()).thenThrow(
        Exception('Logout failed'),
      );

      final result = await repository.logout();

      expect(result.isLeft(), true);
      verify(() => mockRemoteDataSource.logout()).called(1);
      verifyNever(() => mockIsar.clear());
    });
  });

  group('deleteAccount', () {
    test('clears Isar cache when remote deleteAccount succeeds', () async {
      when(() => mockApiCallHandler.handle<void>(any()))
          .thenAnswer((invocation) async {
        final fn = invocation.positionalArguments[0] as Future<void> Function();
        await fn();
        return const Right(null);
      });
      when(() => mockRemoteDataSource.deleteAccount()).thenAnswer((_) async {});
      when(() => mockIsar.writeTxn<void>(any())).thenAnswer((invocation) async {
        final callback =
            invocation.positionalArguments[0] as Future<void> Function();
        await callback();
      });
      when(() => mockIsar.clear()).thenAnswer((_) async {});

      final result = await repository.deleteAccount();

      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.deleteAccount()).called(1);
      verify(() => mockIsar.clear()).called(1);
    });

    test(
      'returns failure and does not clear Isar when remote delete fails',
      () async {
        when(() => mockApiCallHandler.handle<void>(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'UNSETTLED_BALANCES'),
          ),
        );

        final result = await repository.deleteAccount();

        expect(result.isLeft(), true);
        verifyNever(() => mockIsar.clear());
      },
    );
  });
}
