import 'dart:async';
import 'dart:convert';

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
import 'package:splittr/features/groups/data/mappers/group_preview.dart';
import 'package:splittr/features/groups/data/mappers/member.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/entities/group_preview.dart';
import 'package:splittr/features/groups/domain/entities/member.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';
import 'package:splittr/features/sync/data/datasources/outbox_local_data_source.dart';
import 'package:splittr/features/sync/data/models/outbox_action_isar_model.dart';
import 'package:splittr/features/sync/domain/models/outbox_action_types.dart';
import 'package:splittr/features/sync/domain/services/outbox_worker.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: GroupsRepository)
final class GroupsRepositoryImpl implements GroupsRepository {
  GroupsRepositoryImpl(
    this._apiCallHandler,
    this._groupsRemoteDataSource,
    this._groupsLocalDataSource,
    this._outboxLocalDataSource,
    this._outboxWorker,
  );

  final ApiCallHandler _apiCallHandler;
  final GroupsRemoteDataSource _groupsRemoteDataSource;
  final GroupsLocalDataSource _groupsLocalDataSource;
  final OutboxLocalDataSource _outboxLocalDataSource;
  final OutboxWorker _outboxWorker;
  final Mutex _syncLock = Mutex();

  @override
  Stream<EitherFailure<List<Group>>> get watchGroups => _groupsLocalDataSource
      .watchGroups()
      .map((models) => Right(models.toDomain()));

  @override
  Stream<EitherFailure<Group>> watchGroupById(String id) {
    return _groupsLocalDataSource.watchGroupById(id).map((model) {
      if (model != null) {
        return Right(model.toDomain());
      } else {
        return const Left(ServerFailure(message: 'Group not found'));
      }
    });
  }

  @override
  FutureEitherFailure<Group> getGroupById(String id) async {
    final localGroup = await _groupsLocalDataSource.getGroupById(id);
    if (localGroup != null && !localGroup.isSynced) {
      return Right(localGroup.toDomain());
    }

    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.getGroupById(id),
    );

    return result.fold(
      (failure) {
        if (localGroup != null) {
          return Right(localGroup.toDomain());
        }
        return Left(failure);
      },
      (groupModel) async {
        await _groupsLocalDataSource.saveGroup(groupModel.toIsar());
        return Right(groupModel.toDomain());
      },
    );
  }

  @override
  FutureEitherFailure<List<Member>> getMembers({
    required String groupId,
    MemberStatus? status,
  }) async {
    final localGroup = await _groupsLocalDataSource.getGroupById(groupId);
    if (localGroup != null && !localGroup.isSynced) {
      return Right(localGroup.members?.toDomain() ?? []);
    }

    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.getMembers(
        groupId,
        status: status,
      ),
    );

    return result.map((members) => members.toDomain());
  }

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
        (failure) async {
          final cachedModels = await _groupsLocalDataSource.getGroups(
            limit: limit,
          );
          if (cachedModels.isNotEmpty) {
            return Right(
              PaginatedList(
                items: cachedModels.toDomain(),
                pagination: const Pagination(hasMore: false),
              ),
            );
          }
          return Left(failure);
        },
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
    bool? requireAdminApproval,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.createGroup(
        name: name,
        description: description,
        requireAdminApproval: requireAdminApproval,
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
  FutureEitherFailure<Group> updateGroup({
    required String groupId,
    String? name,
    String? description,
    bool? requireAdminApproval,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.updateGroup(
        groupId: groupId,
        name: name,
        description: description,
        requireAdminApproval: requireAdminApproval,
      ),
    );

    return result.fold(
      (failure) async {
        final cached = await _groupsLocalDataSource.getGroupById(groupId);
        if (cached != null) {
          if (name != null) cached.name = name;
          if (description != null) cached.description = description;
          if (requireAdminApproval != null) {
            cached.requireAdminApproval = requireAdminApproval;
          }
          cached.updatedAt = DateTime.now();
          await _groupsLocalDataSource.saveGroup(cached);

          final action = OutboxActionIsarModel()
            ..actionType = OutboxActionTypes.updateGroup
            ..idempotencyKey = const Uuid().v4()
            ..payloadJson = jsonEncode({
              'groupId': groupId,
              'name': ?name,
              'description': ?description,
              'requireAdminApproval': ?requireAdminApproval,
            })
            ..createdAt = DateTime.now();

          await _outboxLocalDataSource.enqueue(action);
          _outboxWorker.flush().ignore();

          return Right(cached.toDomain());
        }
        return Left(failure);
      },
      (groupModel) async {
        await _groupsLocalDataSource.saveGroup(groupModel.toIsar());
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
  FutureEitherFailure<GroupPreview> getGroupPreview({
    required String inviteCode,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.getGroupPreview(inviteCode),
    );

    return result.map((groupPreviewModel) => groupPreviewModel.toDomain());
  }

  @override
  FutureEitherFailureUnit deleteGroup({required String groupId}) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.deleteGroup(groupId: groupId),
    );

    return result.fold(
      (failure) async {
        await _groupsLocalDataSource.deleteGroup(groupId);
        final action = OutboxActionIsarModel()
          ..actionType = OutboxActionTypes.deleteGroup
          ..idempotencyKey = const Uuid().v4()
          ..payloadJson = jsonEncode({'groupId': groupId})
          ..createdAt = DateTime.now();

        await _outboxLocalDataSource.enqueue(action);
        _outboxWorker.flush().ignore();
        return const Right(unit);
      },
      (_) async {
        await _groupsLocalDataSource.deleteGroup(groupId);
        return const Right(unit);
      },
    );
  }

  // TODO(Chaitanya): Update caching
  @override
  FutureEitherFailureUnit addMembers({
    required String groupId,
    required List<String> userIds,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.addMembers(
        groupId: groupId,
        userIds: userIds,
      ),
    );
    return result;
  }

  @override
  FutureEitherFailureUnit leaveOrRemoveGroup({
    required String groupId,
    required String userId,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.leaveOrRemoveGroup(
        groupId: groupId,
        userId: userId,
      ),
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

  @override
  FutureEitherFailure<Member> updateMemberRole({
    required String groupId,
    required String userId,
    required Role role,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.updateMemberRole(
        groupId: groupId,
        userId: userId,
        role: role,
      ),
    );

    return result.fold(
      Left.new,
      (memberModel) async {
        await _groupsLocalDataSource.updateMember(
          groupId: groupId,
          member: memberModel.toIsar(),
        );
        return Right(memberModel.toDomain());
      },
    );
  }

  @override
  FutureEitherFailure<Member> decideJoinRequest({
    required String groupId,
    required String userId,
    required JoinRequestDecision decision,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.decideJoinRequest(
        groupId: groupId,
        userId: userId,
        decision: decision,
      ),
    );

    return result.fold(
      Left.new,
      (memberModel) async {
        await _groupsLocalDataSource.updateMember(
          groupId: groupId,
          member: memberModel.toIsar(),
        );
        return Right(memberModel.toDomain());
      },
    );
  }

  @override
  FutureEitherFailure<Group> resetInviteCode({
    required String groupId,
  }) async {
    final result = await _apiCallHandler.handle(
      () => _groupsRemoteDataSource.resetInviteCode(
        groupId: groupId,
      ),
    );

    return result.fold(
      Left.new,
      (groupModel) async {
        await _groupsLocalDataSource.saveGroup(groupModel.toIsar());
        return Right(groupModel.toDomain());
      },
    );
  }
}
