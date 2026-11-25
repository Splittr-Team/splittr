import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
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
    this._isar,
  );

  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final ApiCallHandler _apiCallHandler;
  final Isar _isar;

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
    return result.fold(
      Left.new,
      (userModel) async {
        await _authLocalDataSource.saveUser(userModel.toIsar());
        final domainUser = userModel.toDomain();
        _authStateStreamController.add(Some(domainUser));
        return Right(domainUser);
      },
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
    return result.fold(
      Left.new,
      (userModel) async {
        await _authLocalDataSource.saveUser(userModel.toIsar());
        final domainUser = userModel.toDomain();
        _authStateStreamController.add(Some(domainUser));
        return Right(domainUser);
      },
    );
  }

  @override
  FutureEitherFailure<User> checkAuthStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.isAnonymous) {
        const guestUser = User(id: 'guest', name: 'Guest');
        _authStateStreamController.add(const Some(guestUser));
        return const Right(guestUser);
      }
    } on Exception catch (e) {
      return Left(e.toFailure());
    }

    final cachedUser = await _authLocalDataSource.getUser();
    if (cachedUser != null) {
      _authStateStreamController.add(Some(cachedUser.toDomain()));
    }

    final result = await _apiCallHandler.handle(
      _authRemoteDataSource.checkAuthStatus,
    );

    return result.fold(
      (failure) {
        if (cachedUser != null && FirebaseAuth.instance.currentUser != null) {
          return Right(cachedUser.toDomain());
        }
        _authStateStreamController.add(const None());
        return Left(failure);
      },
      (userModel) async {
        await _authLocalDataSource.saveUser(userModel.toIsar());
        final domainUser = userModel.toDomain();
        _authStateStreamController.add(Some(domainUser));
        return Right(domainUser);
      },
    );
  }

  @override
  FutureEitherFailure<Unit> logout() async {
    try {
      await _authRemoteDataSource.logout();
      await _isar.writeTxn(() async => _isar.clear());
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
      _authStateStreamController.add(
        const Some(User(id: 'guest', name: 'Guest')),
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
