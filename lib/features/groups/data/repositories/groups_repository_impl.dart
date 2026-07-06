import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/groups/data/datasources/groups_datasource.dart';
import 'package:splittr/features/groups/data/mappers/groups.dart';
import 'package:splittr/features/groups/domain/entities/groups.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@LazySingleton(as: GroupsRepository)
final class GroupsRepositoryImpl implements GroupsRepository {
  const GroupsRepositoryImpl(this._apiCallHandler, this._groupsDataSource);
  final GroupsDatasource _groupsDataSource;
  final ApiCallHandler _apiCallHandler;

  @override
  FutureEitherFailure<Groups> createGroup({
    required String description,
    required String name,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsDataSource.createGroup(
        description: description,
        name: name,
      ),
    );
    return result.map((groups) => groups.toDomain());
  }

  @override
  FutureEitherFailure<Groups> fetchGroups() async {
    final result = await _apiCallHandler.handle(
      _groupsDataSource.fetchGroups,
    );
    return result.map((groups) => groups.toDomain());
  }
}
