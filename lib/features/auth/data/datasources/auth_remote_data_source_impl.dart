import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/data/datasources/auth_api_client.dart';
import 'package:splittr/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:splittr/features/auth/data/models/create_user_payload.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/utils/extensions/firebase_extensions.dart';

@LazySingleton(as: AuthRemoteDataSource)
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(
    this._firebaseAuth,
    this._authApiClient,
    this._googleSignIn,
  );

  final FirebaseAuth _firebaseAuth;
  final AuthApiClient _authApiClient;
  final GoogleSignIn _googleSignIn;

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await _authApiClient.getMe();
    } on FirebaseException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null && currentUser.isAnonymous) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await currentUser.linkWithCredential(credential);
      } else {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      return await _authApiClient.createUser(
        CreateUserPayload(name: name, email: email),
      );
    } on FirebaseException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<UserModel> checkAuthStatus() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const ServerException(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
        );
      }
      return await _authApiClient.getMe();
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
      final user = _firebaseAuth.currentUser!;
      return UserModel(
        id: user.uid,
        name: 'Guest',
      );
    } on FirebaseException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      OAuthCredential? credential;
      try {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw const ServerException(
            message: 'Google sign-in was cancelled',
            code: 'SIGN_IN_CANCELLED',
          );
        }
        final googleAuth = await googleUser.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } on ServerException {
        rethrow;
      } on Exception catch (_) {
        // Fallback to signInWithProvider if native sign-in is not
        // supported on platform.
      }

      if (credential != null) {
        final currentUser = _firebaseAuth.currentUser;
        if (currentUser != null && currentUser.isAnonymous) {
          await currentUser.linkWithCredential(credential);
        } else {
          await _firebaseAuth.signInWithCredential(credential);
        }
      } else {
        final provider = GoogleAuthProvider();
        final currentUser = _firebaseAuth.currentUser;
        if (currentUser != null && currentUser.isAnonymous) {
          await currentUser.linkWithProvider(provider);
        } else {
          await _firebaseAuth.signInWithProvider(provider);
        }
      }

      final firebaseUser = _firebaseAuth.currentUser;
      UserModel userModel;
      try {
        userModel = await _authApiClient.getMe();
      } on Exception catch (_) {
        userModel = await _authApiClient.createUser(
          CreateUserPayload(
            name: firebaseUser?.displayName ?? 'User',
            email: firebaseUser?.email ?? '',
          ),
        );
      }
      return userModel;
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
