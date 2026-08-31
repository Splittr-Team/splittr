import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'user_isar_model.g.dart';

@collection
class UserIsarModel with IsarCacheable {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? id;

  String? name;
  String? email;
  String? phone;
  String? defaultCurrency;
  bool? autoAcceptFriendRequests;
  DateTime? updatedAt;
}
