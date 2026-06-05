import 'package:splittr/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signupWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel?> checkAuthStatus();

  Future<void> logout();
}
