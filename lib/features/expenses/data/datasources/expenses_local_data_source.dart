import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/expenses/data/models/expense_isar_model.dart';

abstract interface class ExpensesLocalDataSource {
  Stream<List<ExpenseIsarModel>> watchExpenses({String? groupId});

  Future<List<ExpenseIsarModel>> getExpenses({String? groupId, int? limit});

  Future<void> saveExpense(ExpenseIsarModel expense);

  Future<void> saveExpenses({
    required List<ExpenseIsarModel> expenses,
    required String? nextCursor,
    required bool hasMore,
  });

  Future<PaginationMetadataIsarModel?> getPaginationMetadata(
    FeatureCacheKey featureKey,
  );

  Future<void> deleteExpense(String id);
}
