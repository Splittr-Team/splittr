import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/quick_split/data/models/split_history_isar_model.dart';

class QuickSplitIsarSchemaProvider implements IsarSchemaProvider {
  const QuickSplitIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    SplitHistoryIsarModelSchema,
  ];
}
