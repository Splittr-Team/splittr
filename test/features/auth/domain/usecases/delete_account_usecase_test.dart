import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';
import 'package:splittr/features/auth/domain/usecases/delete_account_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late DeleteAccountUseCase deleteAccountUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    deleteAccountUseCase = DeleteAccountUseCase(mockAuthRepository);
  });

  test('DeleteAccountUseCase calls repository.deleteAccount', () async {
    when(() => mockAuthRepository.deleteAccount())
        .thenAnswer((_) async => const Right<Failure, Unit>(unit));

    final result = await deleteAccountUseCase.call(noParams);

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => mockAuthRepository.deleteAccount()).called(1);
  });
}
