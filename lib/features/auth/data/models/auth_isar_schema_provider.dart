import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/auth/data/models/user_isar_model.dart';

class AuthIsarSchemaProvider implements IsarSchemaProvider {
  const AuthIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    UserIsarModelSchema,
  ];
}
