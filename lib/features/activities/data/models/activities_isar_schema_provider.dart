import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/activities/data/models/activity_isar_model.dart';

class ActivitiesIsarSchemaProvider implements IsarSchemaProvider {
  const ActivitiesIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    ActivityIsarModelSchema,
  ];
}
