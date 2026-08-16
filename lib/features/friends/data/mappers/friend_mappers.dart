import 'package:sky_utils/sky_utils.dart';
import 'package:splittr/features/friends/data/models/friend_isar_model.dart';
import 'package:splittr/features/friends/data/models/friend_model.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';

extension FriendModelX on FriendModel {
  FriendIsarModel toIsar() => FriendIsarModel()
    ..id = id
    ..name = name
    ..email = email
    ..phone = phone
    ..defaultCurrency = defaultCurrency
    ..status = status
    ..actionUserId = actionUserId
    ..createdAt = createdAt != null ? DateTime.tryParse(createdAt!) : null
    ..updatedAt = updatedAt != null ? DateTime.tryParse(updatedAt!) : null;

  Friend toDomain() => Friend(
    id: id ?? '',
    name: name ?? '',
    email: email ?? '',
    phone: phone,
    defaultCurrency: defaultCurrency,
    createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    status: FriendshipStatus.values.byNameOrNull(status),
    actionUserId: actionUserId,
  );
}

extension FriendModelListX on List<FriendModel> {
  List<FriendIsarModel> toIsar() => map((e) => e.toIsar()).toList();

  List<Friend> toDomain() => map((e) => e.toDomain()).toList();
}

extension FriendIsarModelX on FriendIsarModel {
  Friend toDomain() => Friend(
    id: id ?? '',
    name: name ?? '',
    email: email ?? '',
    phone: phone,
    defaultCurrency: defaultCurrency,
    createdAt: createdAt,
    updatedAt: updatedAt,
    status: FriendshipStatus.values.byNameOrNull(status),
    actionUserId: actionUserId,
  );
}

extension FriendIsarModelListX on List<FriendIsarModel> {
  List<Friend> toDomain() => map((e) => e.toDomain()).toList();
}
