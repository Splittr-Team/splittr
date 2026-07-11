import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Stream<Option<User>> get watchAuthState;

  FutureEitherFailure<User> loginWithEmail({
    required String email,
    required String password,
  });

  FutureEitherFailure<User> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  FutureEitherFailure<User> checkAuthStatus();

  FutureEitherFailure<Unit> logout();

  FutureEitherFailure<Unit> saveGuestSession();

  Future<bool> isGuestUser();

  Future<void> dispose();
}
