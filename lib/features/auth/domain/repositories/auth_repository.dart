import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/auth_provider_type.dart';
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

  FutureEitherFailure<User> loginWithGoogle();

  FutureEitherFailure<User> checkAuthStatus();

  FutureEitherFailure<Unit> logout();

  FutureEitherFailure<Unit> saveGuestSession();

  Future<bool> isGuestUser();

  FutureEitherFailure<void> sendEmailVerification();

  FutureEitherFailure<bool> checkEmailVerified();

  bool get isEmailVerified;

  String get currentUserEmail;

  AuthProviderType get currentAuthProvider;

  Future<void> dispose();
}
