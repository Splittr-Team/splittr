import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/core/network/pagination_model.dart';
import 'package:splittr/core/storage/models/pagination_metadata_isar_model.dart';
import 'package:splittr/features/groups/data/datasources/groups_local_data_source.dart';
import 'package:splittr/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:splittr/features/groups/data/models/group_isar_model.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';
import 'package:splittr/features/groups/data/models/groups_response_model.dart';
import 'package:splittr/features/groups/data/repositories/groups_repository_impl.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';
import 'package:splittr/features/sync/data/datasources/outbox_local_data_source.dart';
import 'package:splittr/features/sync/data/models/outbox_action_isar_model.dart';
import 'package:splittr/features/sync/domain/services/outbox_worker.dart';

class MockGroupsRemoteDataSource extends Mock
    implements GroupsRemoteDataSource {}

class MockGroupsLocalDataSource extends Mock implements GroupsLocalDataSource {}

class MockOutboxLocalDataSource extends Mock implements OutboxLocalDataSource {}

class MockOutboxWorker extends Mock implements OutboxWorker {}

class FakeGroupIsarModel extends Fake implements GroupIsarModel {}

class FakeOutboxActionIsarModel extends Fake implements OutboxActionIsarModel {}

class MockApiCallHandler extends Mock implements ApiCallHandler {
  @override
  Future<Either<Failure, T>> handle<T>(Future<T> Function() call) async {
    try {
      final res = await call();
      return Right(res);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGroupIsarModel());
    registerFallbackValue(FakeOutboxActionIsarModel());
    registerFallbackValue(FeatureCacheKey.groups);
  });

  late MockGroupsRemoteDataSource mockRemoteDataSource;
  late MockGroupsLocalDataSource mockLocalDataSource;
  late MockOutboxLocalDataSource mockOutboxLocalDataSource;
  late MockOutboxWorker mockOutboxWorker;
  late MockApiCallHandler mockHandler;
  late GroupsRepository repository;

  setUp(() {
    mockRemoteDataSource = MockGroupsRemoteDataSource();
    mockLocalDataSource = MockGroupsLocalDataSource();
    mockOutboxLocalDataSource = MockOutboxLocalDataSource();
    mockOutboxWorker = MockOutboxWorker();
    mockHandler = MockApiCallHandler();

    when(
      () => mockOutboxLocalDataSource.enqueue(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockOutboxWorker.flush(),
    ).thenAnswer((_) async => const Right(unit));
    when(
      () => mockLocalDataSource.saveGroup(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockLocalDataSource.getPaginationMetadata(any()),
    ).thenAnswer((_) async => null);
    when(
      () => mockLocalDataSource.getGroups(limit: any(named: 'limit')),
    ).thenAnswer((_) async => []);
    when(
      () => mockRemoteDataSource.getGroups(
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => const GroupsResponseModel(
        data: [],
        pagination: PaginationModel(hasMore: false),
      ),
    );
    when(
      () => mockLocalDataSource.saveGroups(
        groups: any(named: 'groups'),
        nextCursor: any(named: 'nextCursor'),
        hasMore: any(named: 'hasMore'),
      ),
    ).thenAnswer((_) async {});

    repository = GroupsRepositoryImpl(
      mockHandler,
      mockRemoteDataSource,
      mockLocalDataSource,
      mockOutboxLocalDataSource,
      mockOutboxWorker,
    );
  });

  group('createGroup', () {
    test(
      'creates group remotely, saves to local with isSynced=true, '
      'returns Group entity',
      () async {
        const groupModel = GroupModel(
          id: 'server-group-1',
          name: 'Trip to Paris',
          description: 'Vacation',
          createdBy: 'user-1',
        );

        when(
          () => mockRemoteDataSource.createGroup(
            name: 'Trip to Paris',
            description: 'Vacation',
          ),
        ).thenAnswer((_) async => groupModel);

        final result = await repository.createGroup(
          name: 'Trip to Paris',
          description: 'Vacation',
        );

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('should succeed'),
          (group) {
            expect(group.id, 'server-group-1');
            expect(group.name, 'Trip to Paris');
            expect(group.isSynced, true);
          },
        );

        verify(() => mockLocalDataSource.saveGroup(any())).called(1);
      },
    );
  });

  group('getGroupById', () {
    test(
      'returns local group directly without remote call if !isSynced',
      () async {
        final unsyncedGroup = GroupIsarModel()
          ..id = 'local-group-1'
          ..name = 'Local Group'
          ..description = 'Local Desc'
          ..isSynced = false;

        when(
          () => mockLocalDataSource.getGroupById('local-group-1'),
        ).thenAnswer((_) async => unsyncedGroup);

        final result = await repository.getGroupById('local-group-1');

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('should succeed'),
          (group) {
            expect(group.id, 'local-group-1');
            expect(group.isSynced, false);
          },
        );

        verifyNever(() => mockRemoteDataSource.getGroupById('local-group-1'));
      },
    );

    test('fetches remote and updates cache when synced', () async {
      final syncedGroup = GroupIsarModel()
        ..id = 'server-group-1'
        ..name = 'Old Name'
        ..description = 'Desc'
        ..isSynced = true;

      const remoteGroup = GroupModel(
        id: 'server-group-1',
        name: 'New Name',
        description: 'Desc',
      );

      when(
        () => mockLocalDataSource.getGroupById('server-group-1'),
      ).thenAnswer((_) async => syncedGroup);
      when(
        () => mockRemoteDataSource.getGroupById('server-group-1'),
      ).thenAnswer((_) async => remoteGroup);

      final result = await repository.getGroupById('server-group-1');

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('should succeed'),
        (group) {
          expect(group.id, 'server-group-1');
          expect(group.name, 'New Name');
          expect(group.isSynced, true);
        },
      );

      verify(
        () => mockRemoteDataSource.getGroupById('server-group-1'),
      ).called(1);
      verify(() => mockLocalDataSource.saveGroup(any())).called(1);
    });

    test('falls back to local cache when remote call fails', () async {
      final cachedGroup = GroupIsarModel()
        ..id = 'server-group-1'
        ..name = 'Cached Name'
        ..description = 'Desc'
        ..isSynced = true;

      when(
        () => mockLocalDataSource.getGroupById('server-group-1'),
      ).thenAnswer((_) async => cachedGroup);
      when(
        () => mockRemoteDataSource.getGroupById('server-group-1'),
      ).thenThrow(Exception('No internet'));

      final result = await repository.getGroupById('server-group-1');

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('should succeed'),
        (group) {
          expect(group.id, 'server-group-1');
          expect(group.name, 'Cached Name');
        },
      );
    });
  });
}
