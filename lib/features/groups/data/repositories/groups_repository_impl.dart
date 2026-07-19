import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_network/sky_network.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:splittr/features/groups/data/mappers/group.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@LazySingleton(as: GroupsRepository)
final class GroupsRepositoryImpl implements GroupsRepository {
  GroupsRepositoryImpl(this._apiCallHandler, this._groupsRemoteDataSource);

  final ApiCallHandler _apiCallHandler;
  final GroupsRemoteDataSource _groupsRemoteDataSource;

  final BehaviorSubject<EitherFailure<List<Group>>> _groupsSubject =
      BehaviorSubject.seeded(const Right([]));

  @override
  ValueStream<EitherFailure<List<Group>>> get watchGroups =>
      _groupsSubject.stream;

  @override
  FutureEitherFailure<PaginatedList<Group>> getGroups({
    String? cursor,
    int? limit,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.getGroups(
        cursor: cursor,
        limit: limit,
      ),
    );

    return result.map((response) {
      final newGroups = response.data.toDomain();
      final pagination = response.pagination.toDomain();

      final currentList = _groupsSubject.value.getOrElse((_) => []);

      final updatedList = cursor == null
          ? newGroups
          : [...currentList, ...newGroups];

      _groupsSubject.add(Right(updatedList));
      return PaginatedList(items: newGroups, pagination: pagination);
    });
  }

  @override
  FutureEitherFailure<Group> createGroup({
    required String name,
    required String description,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.createGroup(
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
  FutureEitherFailure<Group> joinGroup({required String inviteCode}) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.joinGroup(inviteCode: inviteCode),
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
