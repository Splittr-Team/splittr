import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:splittr/features/groups/data/mappers/group.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@LazySingleton(as: GroupsRepository)
final class GroupsRepositoryImpl implements GroupsRepository {
  GroupsRepositoryImpl(this._apiCallHandler, this._groupsDataSource);

  final ApiCallHandler _apiCallHandler;
  final GroupsDataSource _groupsDataSource;

  final BehaviorSubject<EitherFailure<List<Group>>> _groupsSubject =
      BehaviorSubject.seeded(const Right([]));

  @override
  ValueStream<EitherFailure<List<Group>>> get watchGroups =>
      _groupsSubject.stream;

  @override
  FutureEitherFailure<List<Group>> getGroups() async {
    final result = await _apiCallHandler.handle(
      _groupsDataSource.getGroups,
    );

    final groupsOrFailure = result.map((groups) => groups.toDomain());
    _groupsSubject.add(groupsOrFailure);

    return groupsOrFailure;
  }

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

    return result.map((groupModel) {
      unawaited(getGroups());
      return groupModel.toDomain();
    });
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _groupsSubject.close();
  }
}
