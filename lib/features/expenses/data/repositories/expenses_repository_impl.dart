import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:sky_utils/sky_utils.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_local_data_source.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:splittr/features/expenses/data/mappers/expense_mappers.dart';
import 'package:splittr/features/expenses/data/models/create_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/settle_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/update_expense_payload.dart';
import 'package:splittr/features/expenses/domain/entities/balances.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/entities/input_split.dart';
import 'package:splittr/features/expenses/domain/entities/split_type.dart';
import 'package:splittr/features/expenses/domain/repositories/expenses_repository.dart';

@LazySingleton(as: ExpensesRepository)
final class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl(
    this._apiCallHandler,
    this._expensesRemoteDataSource,
    this._expensesLocalDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final ExpensesRemoteDataSource _expensesRemoteDataSource;
  final ExpensesLocalDataSource _expensesLocalDataSource;
  final Mutex _syncLock = Mutex();

  @override
  Stream<EitherFailure<List<Expense>>> watchExpenses({
    String? groupId,
    bool? personal,
    String? friendId,
  }) => _expensesLocalDataSource
      .watchExpenses(groupId: groupId, personal: personal, friendId: friendId)
      .map((models) => Right(models.toDomain()));

  @override
  FutureEitherFailure<PaginatedList<Expense>> getExpenses({
    String? cursor,
    int? limit,
    String? groupId,
    bool? personal,
    String? friendId,
  }) async {
    return _syncLock.protect(() async {
      var effectiveCursor = cursor;

      if (cursor != null) {
        final meta = await _expensesLocalDataSource.getPaginationMetadata(
          FeatureCacheKey.expenses,
        );
        if (meta != null && !meta.hasMore) {
          return const Right(
            PaginatedList(
              items: [],
              pagination: Pagination(hasMore: false),
            ),
          );
        }
        effectiveCursor = meta?.nextCursor ?? cursor;
      }

      final result = await _apiCallHandler.handle(
        () => _expensesRemoteDataSource.getExpenses(
          cursor: effectiveCursor,
          limit: limit,
          groupId: groupId,
          personal: personal,
          friendId: friendId,
        ),
      );

      return result.fold(
        Left.new,
        (response) async {
          final domainExpenses = response.data.toDomain();
          final pagination = response.pagination.toDomain();

          await _expensesLocalDataSource.saveExpenses(
            expenses: response.data.toIsar(),
            nextCursor: pagination.nextCursor,
            hasMore: pagination.hasMore,
          );

          return Right(
            PaginatedList(items: domainExpenses, pagination: pagination),
          );
        },
      );
    });
  }

  @override
  FutureEitherFailure<Expense> createExpense({
    required String description,
    required num amount,
    required String currency,
    required String paidBy,
    required SplitType splitType,
    required List<InputSplit> splits,
    String? category,
    String? groupId,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _expensesRemoteDataSource.createExpense(
        CreateExpensePayload(
          description: description,
          amount: amount,
          currency: currency,
          paidBy: paidBy,
          splitType: splitType.constantCase,
          splits: splits.toModel(),
          category: category,
          groupId: groupId,
        ),
      ),
    );

    return result.fold(
      Left.new,
      (details) async {
        await _expensesLocalDataSource.saveExpense(details.toIsar());
        return Right(details.toDomain());
      },
    );
  }

  @override
  FutureEitherFailure<Expense> getExpenseDetails(String id) async {
    final result = await _apiCallHandler.handle(
      () => _expensesRemoteDataSource.getExpenseDetails(id),
    );

    return result.fold(
      (failure) async {
        final cached = await _expensesLocalDataSource.getExpenseById(id);
        if (cached != null) {
          return Right(cached.toDomain());
        }
        return Left(failure);
      },
      (details) async {
        await _expensesLocalDataSource.saveExpense(details.toIsar());
        return Right(details.toDomain());
      },
    );
  }

  @override
  FutureEitherFailure<Expense> updateExpense({
    required String id,
    String? description,
    num? amount,
    String? currency,
    String? category,
    SplitType? splitType,
    List<InputSplit>? splits,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _expensesRemoteDataSource.updateExpense(
        id,
        UpdateExpensePayload(
          description: description,
          amount: amount,
          currency: currency,
          category: category,
          splitType: splitType?.name.constantCase,
          splits: splits?.toModel(),
        ),
      ),
    );

    return result.fold(
      Left.new,
      (details) async {
        await _expensesLocalDataSource.saveExpense(details.toIsar());
        return Right(details.toDomain());
      },
    );
  }

  @override
  FutureEitherFailureUnit deleteExpense(String id) async {
    final result = await _apiCallHandler.handle(
      () => _expensesRemoteDataSource.deleteExpense(id),
    );

    return result.fold(
      Left.new,
      (_) async {
        await _expensesLocalDataSource.deleteExpense(id);
        return const Right(unit);
      },
    );
  }

  @override
  FutureEitherFailure<Expense> settleExpense({
    required num amount,
    required String currency,
    required String paidBy,
    required String receivedBy,
    String? groupId,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _expensesRemoteDataSource.settleExpense(
        SettleExpensePayload(
          amount: amount,
          currency: currency,
          paidBy: paidBy,
          receivedBy: receivedBy,
          groupId: groupId,
        ),
      ),
    );

    return result.fold(
      Left.new,
      (details) async {
        await _expensesLocalDataSource.saveExpense(details.toIsar());
        return Right(details.toDomain());
      },
    );
  }

  @override
  FutureEitherFailure<Balances> getBalances({
    String? groupId,
    bool? simplified,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _expensesRemoteDataSource.getBalances(
        groupId: groupId,
        simplified: simplified,
      ),
    );
    return result.map((balancesModel) => balancesModel.toDomain());
  }
}
