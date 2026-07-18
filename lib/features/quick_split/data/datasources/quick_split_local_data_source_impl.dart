import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/quick_split/data/datasources/quick_split_local_data_source.dart';
import 'package:splittr/features/quick_split/data/models/split_history_isar_model.dart';
import 'package:splittr/features/quick_split/domain/entities/split_history.dart';

@Injectable(as: QuickSplitLocalDataSource)
class QuickSplitLocalDataSourceImpl implements QuickSplitLocalDataSource {
  QuickSplitLocalDataSourceImpl(this._isar);

  final Isar _isar;

  IsarDao<SplitHistoryIsarModel> get _dao =>
      IsarDao<SplitHistoryIsarModel>(collection: _isar.splitHistoryIsarModels);

  @override
  Future<void> cacheSplit(SplitHistory split) async {
    // Find existing model to preserve auto-increment isarId
    final existing = await _isar.splitHistoryIsarModels
        .filter()
        .idEqualTo(split.id)
        .findFirst();

    final model = SplitHistoryIsarModel.fromEntity(split);
    if (existing != null) {
      model.isarId = existing.isarId;
    }

    await _isar.writeTxn(() async {
      await _isar.splitHistoryIsarModels.put(model);
    });
  }

  @override
  Future<List<SplitHistory>> fetchCachedSplits() async {
    final models = await _dao.getAll();
    return models.map((model) => model.toEntity()).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
