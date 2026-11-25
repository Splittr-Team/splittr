import 'package:splittr/features/auth/data/models/user_isar_model.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';

extension UserModelX on UserModel {
  User toDomain() => User(
    id: id,
    name: name,
    email: email,
    phone: phone,
    defaultCurrency: defaultCurrency,
  );

  UserIsarModel toIsar() => UserIsarModel()
    ..id = id
    ..name = name
    ..email = email
    ..phone = phone
    ..defaultCurrency = defaultCurrency
    ..updatedAt = DateTime.now();
}

extension UserModelListX on List<UserModel> {
  List<User> toDomain() => map((m) => m.toDomain()).toList();
}

extension UserIsarModelX on UserIsarModel {
  User toDomain() => User(
    id: id,
    name: name,
    email: email,
    phone: phone,
    defaultCurrency: defaultCurrency,
  );
}
