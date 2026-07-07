import 'package:fpdart/fpdart.dart' hide Group;
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:splittr/features/groups/data/mappers/group.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@LazySingleton(as: GroupsRepository)
final class GroupsRepositoryImpl implements GroupsRepository {
  // Removed 'const' to allow BehaviorSubject initialization
  GroupsRepositoryImpl(this._apiCallHandler, this._groupsDataSource);

  final GroupsDataSource _groupsDataSource;
  final ApiCallHandler _apiCallHandler;

  // 1. Initialize the BehaviorSubject with an empty list
  final BehaviorSubject<EitherFailure<List<Group>>> _groupsSubject =
      BehaviorSubject.seeded(
        const Right([]),
      );

  // 2. Expose the stream for your Bloc to listen to
  @override
  Stream<EitherFailure<List<Group>>> get watchGroups => _groupsSubject.stream;

  @override
  FutureEitherFailure<Group> createGroup({
    required String name,
    required String description,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsDataSource.createGroup(
        name: name,
        description: description,
      ),
    );

    return result.fold(
      (failure) {
        _groupsSubject.add(Left(failure));
        return Left(failure);
      },
      (groupModel) {
        final group = groupModel.toDomain();
        final currentList = _groupsSubject.value.getOrElse((_) => []);
        _groupsSubject.add(Right([...currentList, group]));
        return Right(group);
      },
    );
  }

  @override
  FutureEitherFailure<List<Group>> getGroups() async {
    final result = await _apiCallHandler.handle(
      _groupsDataSource.getGroups,
    );

    return result.fold(
      (failure) {
        _groupsSubject.add(Left(failure));
        return Left(failure);
      },
      (groupsModel) {
        final groupsList = groupsModel
            .map((model) => model.toDomain())
            .toList();
        _groupsSubject.add(Right(groupsList));
        return Right(groupsList);
      },
    );
  }

  // Ensure memory is freed if the repository is ever destroyed
  @override
  @disposeMethod
  Future<void> dispose() async {
    await _groupsSubject.close();
  }
}
