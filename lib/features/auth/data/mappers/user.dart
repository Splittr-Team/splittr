import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';

extension UserModelX on UserModel {
  User toDomain() => User(
    id: id,
    name: name,
    email: email,
    phone: phone,
  );
}

extension UserModelListX on List<UserModel> {
  List<User> toDomain() => map((m) => m.toDomain()).toList();
}
