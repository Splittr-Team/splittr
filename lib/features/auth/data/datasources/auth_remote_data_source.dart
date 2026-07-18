import 'package:splittr/features/auth/data/models/user_model.dart';

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

  Future<void> logout();
}
