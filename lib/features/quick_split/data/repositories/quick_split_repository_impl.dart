import 'package:injectable/injectable.dart';
import 'package:splittr/features/quick_split/data/datasources/quick_split_local_data_source.dart';
import 'package:splittr/features/quick_split/domain/entities/split_history.dart';
import 'package:splittr/features/quick_split/domain/repositories/i_quick_split_repository.dart';

@Injectable(as: IQuickSplitRepository)
class QuickSplitRepositoryImpl implements IQuickSplitRepository {
  QuickSplitRepositoryImpl(this._localDataSource);

  final QuickSplitLocalDataSource _localDataSource;

  @override
  Future<void> saveSplit(SplitHistory split) async {
    await _localDataSource.cacheSplit(split);
  }

  @override
  Future<List<SplitHistory>> getSplitHistory() {
    return _localDataSource.fetchCachedSplits();
  }
}
