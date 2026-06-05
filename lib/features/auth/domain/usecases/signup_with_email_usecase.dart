import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
final class SignupWithEmailUseCase
    implements UseCase<User, SignupWithEmailParams> {
  const SignupWithEmailUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, User>> call(SignupWithEmailParams params) {
    return _authRepository.signupWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class SignupWithEmailParams {
  const SignupWithEmailParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
