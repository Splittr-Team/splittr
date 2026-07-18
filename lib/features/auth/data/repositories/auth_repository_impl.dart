import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:splittr/features/auth/data/mappers/user.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._apiCallHandler,
  );

  final AuthRemoteDataSource _authRemoteDataSource;
  final ApiCallHandler _apiCallHandler;

  final StreamController<Option<User>> _authStateStreamController =
      StreamController<Option<User>>.broadcast();

  @override
  Stream<Option<User>> get watchAuthState => _authStateStreamController.stream;

  @override
  FutureEitherFailure<User> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _authRemoteDataSource.loginWithEmail(
        email: email,
        password: password,
      ),
    );
    return result.map((userModel) => userModel.toDomain())..fold(
      (_) {},
      (user) => _authStateStreamController.add(Some(user)),
    );
  }

  @override
  FutureEitherFailure<User> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _authRemoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      ),
    );
    return result.map((userModel) => userModel.toDomain())..fold(
      (_) {},
      (user) => _authStateStreamController.add(Some(user)),
    );
  }

  @override
  FutureEitherFailure<User> checkAuthStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.isAnonymous) {
        final guestUser = User(
          id: 'guest',
          firebaseUid: user.uid,
          name: 'Guest',
        );
        _authStateStreamController.add(Some(guestUser));
        return Right(guestUser);
      }
    } on Exception catch (e) {
      return Left(e.toFailure());
    }

    final result = await _apiCallHandler.handle(
      _authRemoteDataSource.checkAuthStatus,
    );

    return result.map((userModel) => userModel.toDomain())..fold(
      (failure) => _authStateStreamController.add(const None()),
      (user) => _authStateStreamController.add(Some(user)),
    );
  }

  @override
  FutureEitherFailure<Unit> logout() async {
    try {
      await _authRemoteDataSource.logout();
      _authStateStreamController.add(const None());
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  FutureEitherFailure<Unit> saveGuestSession() async {
    final result = await _apiCallHandler.handle(
      _authRemoteDataSource.signInAnonymously,
    );
    return result.map((_) {
      final user = FirebaseAuth.instance.currentUser!;
      _authStateStreamController.add(
        Some(User(id: 'guest', firebaseUid: user.uid, name: 'Guest')),
      );
      return unit;
    });
  }

  @override
  Future<bool> isGuestUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return user != null && user.isAnonymous;
    } on Exception catch (_) {
      return false;
    }
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    await _authStateStreamController.close();
  }
}
