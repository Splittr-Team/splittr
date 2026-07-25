import 'package:injectable/injectable.dart';
import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_local_data_source.dart';
import 'package:splittr/features/expenses/data/models/expense_isar_model.dart';

@LazySingleton(as: ExpensesLocalDataSource)
class ExpensesLocalDataSourceImpl implements ExpensesLocalDataSource {
  ExpensesLocalDataSourceImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<ExpenseIsarModel>> watchExpenses({String? groupId}) {
    if (groupId != null) {
      return _isar.expenseIsarModels
          .filter()
          .groupIdEqualTo(groupId)
          .sortBySpentAtDesc()
          .watch(fireImmediately: true);
    }
    return _isar.expenseIsarModels.where().sortBySpentAtDesc().watch(
      fireImmediately: true,
    );
  }

  @override
  Future<List<ExpenseIsarModel>> getExpenses({
    String? groupId,
    int? limit,
  }) async {
    final query = groupId != null
        ? _isar.expenseIsarModels
              .filter()
              .groupIdEqualTo(groupId)
              .sortBySpentAtDesc()
        : _isar.expenseIsarModels.where().sortBySpentAtDesc();

    if (limit != null) {
      return query.limit(limit).findAll();
    }
    return query.findAll();
  }

  @override
  Future<void> saveExpense(ExpenseIsarModel expense) async {
    await _isar.writeTxn(() async {
      await _isar.expenseIsarModels.put(expense);
    });
  }

  @override
  Future<void> saveExpenses({
    required List<ExpenseIsarModel> expenses,
    required String? nextCursor,
    required bool hasMore,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.expenseIsarModels.putAll(expenses);

      final meta = PaginationMetadataIsarModel()
        ..featureKey = FeatureCacheKey.expenses
        ..nextCursor = nextCursor
        ..hasMore = hasMore
        ..lastSyncedAt = DateTime.now();

      await _isar.paginationMetadataIsarModels.put(meta);
    });
  }

  @override
  Future<PaginationMetadataIsarModel?> getPaginationMetadata(
    FeatureCacheKey featureKey,
  ) async {
    return _isar.paginationMetadataIsarModels
        .filter()
        .featureKeyEqualTo(featureKey)
        .findFirst();
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _isar.writeTxn(() async {
      await _isar.expenseIsarModels.filter().idEqualTo(id).deleteAll();
    });
  }
}
