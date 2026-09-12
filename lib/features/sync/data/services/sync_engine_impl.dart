import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/sync/data/datasources/sync_local_data_source.dart';
import 'package:splittr/features/sync/data/datasources/sync_remote_data_source.dart';
import 'package:splittr/features/sync/domain/services/sync_engine.dart';

@LazySingleton(as: SyncEngine)
final class SyncEngineImpl implements SyncEngine {
  SyncEngineImpl(
    this._apiCallHandler,
    this._syncRemoteDataSource,
    this._syncLocalDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final SyncRemoteDataSource _syncRemoteDataSource;
  final SyncLocalDataSource _syncLocalDataSource;
  final Mutex _syncLock = Mutex();

  @override
  FutureEitherFailure<Unit> pullSync({int limit = 100}) {
    return _syncLock.protect(() async {
      var meta = await _syncLocalDataSource.getMetadata();

      while (true) {
        final result = await _apiCallHandler.handle(
          () => _syncRemoteDataSource.getSync(
            friendsVersion: meta?.friendsVersion ?? 0,
            groupsVersion: meta?.groupsVersion ?? 0,
            expensesVersion: meta?.expensesVersion ?? 0,
            limit: limit,
          ),
        );

        final response = result.fold((failure) => null, (r) => r);
        if (response == null) {
          return result.map((_) => unit);
        }

        await _syncLocalDataSource.applyDelta(response);

        final hasMoreFriends = response.friends.updated.length >= limit;
        final hasMoreGroups = response.groups.updated.length >= limit;
        final hasMoreExpenses = response.expenses.updated.length >= limit;

        if (!hasMoreFriends && !hasMoreGroups && !hasMoreExpenses) {
          break;
        }

        // Refresh metadata with updated watermarks before next page fetch
        meta = await _syncLocalDataSource.getMetadata();
      }

      return const Right(unit);
    });
  }
}
