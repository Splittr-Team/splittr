import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_network/sky_network.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/groups/data/datasources/groups_local_data_source.dart';
import 'package:splittr/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:splittr/features/groups/data/mappers/group_isar_to_domain.dart';
import 'package:splittr/features/groups/data/mappers/group_model_to_domain.dart';
import 'package:splittr/features/groups/data/mappers/group_model_to_isar.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@LazySingleton(as: GroupsRepository)
final class GroupsRepositoryImpl implements GroupsRepository {
  GroupsRepositoryImpl(
    this._apiCallHandler,
    this._groupsRemoteDataSource,
    this._groupsLocalDataSource,
  );

  final ApiCallHandler _apiCallHandler;
  final GroupsRemoteDataSource _groupsRemoteDataSource;
  final GroupsLocalDataSource _groupsLocalDataSource;
  final Mutex _syncLock = Mutex();

  @override
  Stream<EitherFailure<List<Group>>> get watchGroups => _groupsLocalDataSource
      .watchGroups()
      .map((models) => Right(models.toDomain()));

  @override
  FutureEitherFailure<PaginatedList<Group>> getGroups({
    String? cursor,
    int? limit,
  }) async {
    return _syncLock.protect(() async {
      var effectiveCursor = cursor;

      if (cursor != null) {
        final meta = await _groupsLocalDataSource.getPaginationMetadata(
          FeatureCacheKey.groups,
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
        () => _groupsRemoteDataSource.getGroups(
          cursor: effectiveCursor,
          limit: limit,
        ),
      );

      return result.fold(
        Left.new,
        (response) async {
          final domainGroups = response.data.toDomain();
          final pagination = response.pagination.toDomain();

          await _groupsLocalDataSource.saveGroups(
            groups: response.data.toIsar(),
            nextCursor: pagination.nextCursor,
            hasMore: pagination.hasMore,
          );

          return Right(
            PaginatedList(items: domainGroups, pagination: pagination),
          );
        },
      );
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

    return result.fold(
      Left.new,
      (groupModel) async {
        await _groupsLocalDataSource.saveGroup(groupModel.toIsar());
        unawaited(getGroups());
        return Right(groupModel.toDomain());
      },
    );
  }

  @override
  FutureEitherFailure<Group> joinGroup({required String inviteCode}) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.joinGroup(inviteCode: inviteCode),
    );

    return result.fold(
      Left.new,
      (groupModel) async {
        await _groupsLocalDataSource.saveGroup(groupModel.toIsar());
        unawaited(getGroups());
        return Right(groupModel.toDomain());
      },
    );
  }

  @override
  FutureEitherFailureUnit deleteGroup({required String groupId}) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.deleteGroup(groupId: groupId),
    );

    return result.fold(
      Left.new,
      (_) async {
        await _groupsLocalDataSource.deleteGroup(groupId);
        unawaited(getGroups());
        return const Right(unit);
      },
    );
  }
}
