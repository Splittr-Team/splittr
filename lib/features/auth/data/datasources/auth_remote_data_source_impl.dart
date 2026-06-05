import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:splittr/features/auth/data/mappers/user.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/utils/extensions/firebase_extensions.dart';

@LazySingleton(as: AuthRemoteDataSource)
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._firebaseAuth, this._firebaseFirestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        return firebaseUser.toData();
      } else {
        throw const ServerException(
          message: 'Authentication failed: User object is null.',
        );
      }
    } on FirebaseException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<UserModel> signupWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final userModel = firebaseUser.toData();
        await _firebaseFirestore
            .collection('users')
            .doc(userModel.id)
            .set(
              userModel.toJson()..addAll({
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),
              }),
            );

        return firebaseUser.toData();
      } else {
        throw const ServerException(
          message: 'Authentication failed: User object is null.',
        );
      }
    } on FirebaseException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<UserModel?> checkAuthStatus() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        return null;
      }

      final docSnapshot = await _firebaseFirestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserModel.fromJson(docSnapshot.data()!);
      } else {
        await logout();
        return null;
      }
    } on FirebaseException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<void> logout() {
    try {
      return _firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      throw e.toServerException();
    }
  }
}
