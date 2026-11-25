import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:splittr/features/auth/data/models/user_isar_model.dart';

@LazySingleton(as: AuthLocalDataSource)
final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._isar);

  final Isar _isar;

  @override
  Future<UserIsarModel?> getUser() {
    return _isar.userIsarModels.where().findFirst();
  }

  @override
  Future<void> saveUser(UserIsarModel user) async {
    await _isar.writeTxn(() async {
      await _isar.userIsarModels.clear();
      await _isar.userIsarModels.put(user);
    });
  }
}
