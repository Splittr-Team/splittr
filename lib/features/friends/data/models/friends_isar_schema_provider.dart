import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/friends/data/models/friend_isar_model.dart';

class FriendsIsarSchemaProvider implements IsarSchemaProvider {
  const FriendsIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    FriendIsarModelSchema,
  ];
}
