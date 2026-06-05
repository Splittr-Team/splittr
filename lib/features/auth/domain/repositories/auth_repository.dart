import 'package:fpdart/fpdart.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/utils/typedefs/typedefs.dart';

abstract interface class AuthRepository {
  FutureEitherFailure<User> loginWithEmail({
    required String email,
    required String password,
  });

  FutureEitherFailure<User> signupWithEmail({
    required String email,
    required String password,
  });

  FutureEitherFailure<User> checkAuthStatus();

  FutureEitherFailure<Unit> logout();
}
