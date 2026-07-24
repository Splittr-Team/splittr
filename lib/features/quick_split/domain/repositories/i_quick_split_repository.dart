import 'package:splittr/features/quick_split/domain/entities/split_history.dart';

abstract class IQuickSplitRepository {
  Future<void> saveSplit(SplitHistory split);

  Future<List<SplitHistory>> getSplitHistory();
}
