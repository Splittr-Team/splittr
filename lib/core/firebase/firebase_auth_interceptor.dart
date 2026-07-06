import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_network/sky_network.dart';

@injectable
class FirebaseAuthInterceptor extends BaseAuthInterceptor {
  FirebaseAuthInterceptor(
    this._firebaseAuth,
    @Named('retryDio') Dio dio,
  ) : super(dio: dio);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<String?> getAccessToken() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    print('user.getIdToken() ${await user.getIdToken()}');
    return user.getIdToken();
  }

  @override
  Future<bool> refreshToken() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    try {
      // Force refresh the token from Firebase
      await user.getIdToken(true);
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
