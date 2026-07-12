import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_api_client.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_remote_data_source_impl.dart';
import 'package:splittr/features/expenses/data/models/create_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/expense_model.dart';

class MockExpensesApiClient extends Mock implements ExpensesApiClient {}

void main() {
  late MockExpensesApiClient mockApiClient;
  late ExpensesRemoteDataSource dataSource;

  setUp(() {
    mockApiClient = MockExpensesApiClient();
    dataSource = ExpensesRemoteDataSourceImpl(mockApiClient);
  });

  test(
    'should call createExpense on ApiClient and return ExpenseDetailsModel',
    () async {
      const payload = CreateExpensePayload(
        description: 'Rent',
        amount: 1000,
        currency: 'USD',
        category: 'Rent',
        paidBy: 'user-1',
        splitType: 'EQUAL',
        splits: [],
      );

      final detailsModel = ExpenseDetailsModel(
        expense: ExpenseModel(
          id: 'exp-rent',
          description: 'Rent',
          amount: 1000,
          currency: 'USD',
          category: 'Rent',
          paidBy: 'user-1',
          createdBy: 'user-1',
          isPayment: false,
          spentAt: DateTime(2026, 7, 12),
        ),
        splits: [],
      );

      when(
        () => mockApiClient.createExpense(payload),
      ).thenAnswer((_) async => detailsModel);

      final result = await dataSource.createExpense(payload);

      expect(result.expense.id, 'exp-rent');
      verify(() => mockApiClient.createExpense(payload)).called(1);
    },
  );
}
