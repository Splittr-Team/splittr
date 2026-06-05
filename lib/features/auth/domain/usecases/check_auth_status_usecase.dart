import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
final class CheckAuthStatusUseCase implements UseCase<User, NoParams> {
  const CheckAuthStatusUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return _authRepository.checkAuthStatus();
  }
}
