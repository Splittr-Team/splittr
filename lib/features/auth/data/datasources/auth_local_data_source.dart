import 'package:splittr/features/auth/data/models/user_isar_model.dart';

abstract interface class AuthLocalDataSource {
  Future<UserIsarModel?> getUser();

  Future<void> saveUser(UserIsarModel user);
}
