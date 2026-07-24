import 'package:splittr/features/quick_split/domain/entities/split_history.dart';

abstract class QuickSplitLocalDataSource {
  Future<void> cacheSplit(SplitHistory split);

  Future<List<SplitHistory>> fetchCachedSplits();
}
