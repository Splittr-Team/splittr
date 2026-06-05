import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';

extension UserModelX on UserModel {
  User toDomain() => User(id: id, name: name, email: email, phone: phone);
}

extension FirebaseUserX on firebase_auth.User {
  UserModel toData() =>
      UserModel(id: uid, name: displayName, email: email, phone: phoneNumber);
}
