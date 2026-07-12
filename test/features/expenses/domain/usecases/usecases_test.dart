import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:splittr/features/expenses/domain/usecases/get_expense_details_usecase.dart';

class MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  late MockExpensesRepository mockRepository;
  late GetExpenseDetailsUseCase useCase;

  setUp(() {
    mockRepository = MockExpensesRepository();
    useCase = GetExpenseDetailsUseCase(mockRepository);
  });

  test('should call repository.getExpenseDetails and return Expense', () async {
    final expense = Expense(
      id: 'exp-1',
      description: 'Coffee',
      amount: 4.5,
      currency: 'USD',
      category: 'Food',
      paidBy: 'user-1',
      createdBy: 'user-1',
      isPayment: false,
      spentAt: DateTime(2026, 7, 12),
      splits: [],
    );

    when(
      () => mockRepository.getExpenseDetails('exp-1'),
    ).thenAnswer((_) async => Right(expense));

    final result = await useCase.call('exp-1');

    expect(result.isRight(), true);
    result.fold(
      (f) => fail('should pass'),
      (value) => expect(value.id, 'exp-1'),
    );
    verify(() => mockRepository.getExpenseDetails('exp-1')).called(1);
  });
}
