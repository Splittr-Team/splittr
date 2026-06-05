import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:splittr/features/auth/data/mappers/user.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';
import 'package:splittr/utils/typedefs/typedefs.dart';

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._authRemoteDataSource);

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  FutureEitherFailure<User> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _authRemoteDataSource.loginWithEmail(
        email: email,
        password: password,
      );

      return Right(userModel.toDomain());
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  FutureEitherFailure<User> signupWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _authRemoteDataSource.signupWithEmail(
        email: email,
        password: password,
      );
      return Right(userModel.toDomain());
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  FutureEitherFailure<User> checkAuthStatus() async {
    try {
      final userModel = await _authRemoteDataSource.checkAuthStatus();

      if (userModel != null) {
        return Right(userModel.toDomain());
      }

      return const Left(ServerFailure(message: 'User Not Found'));
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  FutureEitherFailure<Unit> logout() async {
    try {
      await _authRemoteDataSource.logout();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
