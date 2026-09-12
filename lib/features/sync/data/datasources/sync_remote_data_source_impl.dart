import 'package:injectable/injectable.dart';
import 'package:splittr/features/sync/data/datasources/sync_api_client.dart';
import 'package:splittr/features/sync/data/datasources/sync_remote_data_source.dart';
import 'package:splittr/features/sync/data/models/sync_response_model.dart';

@LazySingleton(as: SyncRemoteDataSource)
final class SyncRemoteDataSourceImpl implements SyncRemoteDataSource {
  const SyncRemoteDataSourceImpl(this._client);

  final SyncApiClient _client;

  @override
  Future<SyncResponseModel> getSync({
    int? friendsVersion,
    int? groupsVersion,
    int? expensesVersion,
    int? limit,
  }) {
    return _client.getSync(
      friendsVersion: friendsVersion,
      groupsVersion: groupsVersion,
      expensesVersion: expensesVersion,
      limit: limit,
    );
  }
}
