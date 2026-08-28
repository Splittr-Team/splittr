import 'package:splittr/features/sync/data/models/sync_response_model.dart';

abstract interface class SyncRemoteDataSource {
  Future<SyncResponseModel> getSync({
    int? friendsVersion,
    int? groupsVersion,
    int? expensesVersion,
    int? limit,
  });
}
