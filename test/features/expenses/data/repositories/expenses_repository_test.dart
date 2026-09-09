import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_local_data_source.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/expense_isar_model.dart';
import 'package:splittr/features/expenses/data/models/expense_model.dart';
import 'package:splittr/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

import 'package:splittr/features/sync/data/datasources/outbox_local_data_source.dart';
import 'package:splittr/features/sync/domain/services/outbox_worker.dart';

class MockExpensesRemoteDataSource extends Mock
    implements ExpensesRemoteDataSource {}

class MockExpensesLocalDataSource extends Mock
    implements ExpensesLocalDataSource {}

class FakeExpenseIsarModel extends Fake implements ExpenseIsarModel {}

class MockOutboxLocalDataSource extends Mock implements OutboxLocalDataSource {}

class MockOutboxWorker extends Mock implements OutboxWorker {}

class MockApiCallHandler extends Mock implements ApiCallHandler {
  @override
  Future<Either<Failure, T>> handle<T>(Future<T> Function() call) async {
    try {
      final res = await call();
      return Right(res);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

void main() {
  late MockExpensesRemoteDataSource mockRemoteDataSource;
  late MockExpensesLocalDataSource mockLocalDataSource;
  late MockOutboxLocalDataSource mockOutboxLocalDataSource;
  late MockOutboxWorker mockOutboxWorker;
  late MockApiCallHandler mockHandler;
  late ExpensesRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeExpenseIsarModel());
  });

  setUp(() {
    mockRemoteDataSource = MockExpensesRemoteDataSource();
    mockLocalDataSource = MockExpensesLocalDataSource();
    mockOutboxLocalDataSource = MockOutboxLocalDataSource();
    mockOutboxWorker = MockOutboxWorker();
    mockHandler = MockApiCallHandler();
    repository = ExpensesRepositoryImpl(
      mockHandler,
      mockRemoteDataSource,
      mockLocalDataSource,
      mockOutboxLocalDataSource,
      mockOutboxWorker,
    );
  });

  group('getExpenseDetails', () {
    test(
      'should return Expense entity and cache locally when getExpenseDetails '
      'succeeds',
      () async {
        final detailsModel = ExpenseDetailsModel(
          expense: ExpenseModel(
            id: 'exp-1',
            description: 'Lunch',
            amount: 20,
            currency: 'USD',
            category: 'Food',
            paidBy: 'user-1',
            createdBy: 'user-1',
            isPayment: false,
            spentAt: DateTime(2026, 7, 12),
          ),
          splits: [],
        );

        when(
          () => mockRemoteDataSource.getExpenseDetails('exp-1'),
        ).thenAnswer((_) async => detailsModel);
        when(
          () => mockLocalDataSource.saveExpense(any()),
        ).thenAnswer((_) async {});

        final result = await repository.getExpenseDetails('exp-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('should have succeeded'),
          (expense) => expect(expense.id, 'exp-1'),
        );
        verify(() => mockLocalDataSource.saveExpense(any())).called(1);
      },
    );

    test(
      'should return cached Expense entity when remote call fails and cache '
      'exists',
      () async {
        when(
          () => mockRemoteDataSource.getExpenseDetails('exp-1'),
        ).thenThrow(Exception('Network error'));
        final cached = ExpenseIsarModel()
          ..id = 'exp-1'
          ..description = 'Lunch'
          ..amount = 20
          ..currency = 'USD'
          ..paidBy = 'user-1'
          ..createdBy = 'user-1'
          ..isPayment = false
          ..spentAt = DateTime(2026, 7, 12);
        when(
          () => mockLocalDataSource.getExpenseById('exp-1'),
        ).thenAnswer((_) async => cached);

        final result = await repository.getExpenseDetails('exp-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('should have succeeded'),
          (expense) => expect(expense.id, 'exp-1'),
        );
      },
    );
  });
}
