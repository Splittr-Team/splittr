import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
final class LoginWithEmailUseCase
    implements UseCase<User, LoginWithEmailParams> {
  const LoginWithEmailUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, User>> call(LoginWithEmailParams params) {
    return _authRepository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginWithEmailParams extends Equatable {
  const LoginWithEmailParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
