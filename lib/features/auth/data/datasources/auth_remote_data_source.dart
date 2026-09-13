import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/auth/domain/entities/auth_provider_type.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> checkAuthStatus();

  Future<UserModel> signInAnonymously();

  Future<UserModel> loginWithGoogle();

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerified();

  bool get isEmailVerified;

  String get currentUserEmail;

  AuthProviderType get currentAuthProvider;

  Future<void> logout();
}
