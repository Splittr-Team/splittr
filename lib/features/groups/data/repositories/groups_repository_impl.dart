import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/groups/data/datasources/groups_datasource.dart';
import 'package:splittr/features/groups/data/mappers/groups.dart';
import 'package:splittr/features/groups/domain/entities/groups.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@LazySingleton(as: GroupsRepository)
final class GroupsRepositoryImpl implements GroupsRepository {
  // Removed 'const' to allow BehaviorSubject initialization
  GroupsRepositoryImpl(this._apiCallHandler, this._groupsDataSource);

  final GroupsDatasource _groupsDataSource;
  final ApiCallHandler _apiCallHandler;

  // 1. Initialize the BehaviorSubject with an empty list
  final BehaviorSubject<List<Groups>> _groupsSubject = BehaviorSubject.seeded(
    [],
  );

  // 2. Expose the stream for your Bloc to listen to
  @override
  Stream<List<Groups>> get watchGroups => _groupsSubject.stream;

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

    return result.map((model) {
      final newGroup = model.toDomain();

      // Instantly prepend the newly created group to the current stream cache
      final currentList = _groupsSubject.value;
      _groupsSubject.add([newGroup, ...currentList]);

      return newGroup;
    });
  }

  @override
  FutureEitherFailure<List<Groups>> fetchGroups() async {
    final result = await _apiCallHandler.handle(
      _groupsDataSource.fetchGroups,
    );

    return result.map((modelList) {
      // FIX: Map over the list of models to convert each to a domain entity
      final groupsList = modelList.map((model) => model.toDomain()).toList();

      // Push the fresh list from the API into the stream
      _groupsSubject.add(groupsList);

      return groupsList;
    });
  }

  // Ensure memory is freed if the repository is ever destroyed
  @override
  @disposeMethod
  Future<void> dispose() async {
    await _groupsSubject.close();
  }
}
