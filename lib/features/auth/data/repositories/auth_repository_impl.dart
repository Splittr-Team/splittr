import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:splittr/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:splittr/features/auth/data/mappers/user.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
    this._apiCallHandler,
  );

  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final ApiCallHandler _apiCallHandler;

  final StreamController<Option<User>> _sessionStreamController =
      StreamController<Option<User>>.broadcast();

  @override
  Stream<Option<User>> get authStateChanges => _sessionStreamController.stream;

  @override
  FutureEitherFailure<User> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _authLocalDataSource.clearSession();
    } on Exception catch (_) {}

    final result = await _apiCallHandler.handle(
      () => _authRemoteDataSource.loginWithEmail(
        email: email,
        password: password,
      ),
    );
    return result.map((userModel) => userModel.toDomain())..fold(
      (_) {},
      (user) => _sessionStreamController.add(Some(user)),
    );
  }

  @override
  FutureEitherFailure<User> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _authLocalDataSource.clearSession();
    } on Exception catch (_) {}

    final result = await _apiCallHandler.handle(
      () => _authRemoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      ),
    );
    return result.map((userModel) => userModel.toDomain())..fold(
      (_) {},
      (user) => _sessionStreamController.add(Some(user)),
    );
  }

  @override
  FutureEitherFailure<User> checkAuthStatus() async {
    try {
      final isGuest = await _authLocalDataSource.isGuestUser();
      if (isGuest) {
        const guestUser = User(id: 'guest', name: 'Guest');
        _sessionStreamController.add(const Some(guestUser));
        return const Right(guestUser);
      }
    } on Exception catch (e) {
      return Left(e.toFailure());
    }

    final result = await _apiCallHandler.handle(
      _authRemoteDataSource.checkAuthStatus,
    );

    return result.map((userModel) => userModel.toDomain())..fold(
      (failure) => _sessionStreamController.add(const None()),
      (user) => _sessionStreamController.add(Some(user)),
    );
  }

  @override
  FutureEitherFailure<Unit> logout() async {
    try {
      await (
        _authLocalDataSource.clearSession(),
        _authRemoteDataSource.logout(),
      ).wait;

      _sessionStreamController.add(const None());

      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  FutureEitherFailure<Unit> saveGuestSession() async {
    try {
      await _authLocalDataSource.saveGuestSession();
      _sessionStreamController.add(
        const Some(User(id: 'guest', name: 'Guest')),
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<bool> isGuestUser() async {
    try {
      return await _authLocalDataSource.isGuestUser();
    } on Exception catch (_) {
      return false;
    }
  }
}
