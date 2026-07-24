import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/app_config/data/models/app_config_isar_model.dart';

class AppConfigIsarSchemaProvider implements IsarSchemaProvider {
  const AppConfigIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    AppConfigIsarModelSchema,
  ];
}
