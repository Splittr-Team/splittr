import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'friend_isar_model.g.dart';

@collection
class FriendIsarModel with IsarCacheable {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? id;

  String? name;
  String? email;
  String? phone;
  String? avatarUrl;
  @Index()
  DateTime? createdAt;
}
