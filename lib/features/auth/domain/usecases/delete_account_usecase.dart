import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
final class DeleteAccountUseCase implements UseCase<Unit, NoParams> {
  const DeleteAccountUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _authRepository.deleteAccount();
  }
}
