import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/friends/data/models/friend_isar_model.dart';

extension UserModelFriendX on UserModel {
  FriendIsarModel toIsar() => FriendIsarModel()
    ..id = id
    ..name = name
    ..email = email
    ..phone = phone;
}

extension UserModelFriendListX on List<UserModel> {
  List<FriendIsarModel> toIsar() => map((e) => e.toIsar()).toList();
}

extension FriendIsarModelX on FriendIsarModel {
  User toDomain() => User(
    id: id ?? '',
    name: name ?? '',
    email: email ?? '',
    phone: phone,
  );
}

extension FriendIsarModelListX on List<FriendIsarModel> {
  List<User> toDomain() => map((e) => e.toDomain()).toList();
}
