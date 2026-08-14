import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/core/network/pagination_model.dart';
import 'package:splittr/features/friends/data/datasources/friends_local_data_source.dart';
import 'package:splittr/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:splittr/features/friends/data/models/friend_model.dart';
import 'package:splittr/features/friends/data/models/friends_model.dart';
import 'package:splittr/features/friends/data/repositories/friends_repository_impl.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';

class MockFriendsRemoteDataSource extends Mock
    implements FriendsRemoteDataSource {}

class MockFriendsLocalDataSource extends Mock
    implements FriendsLocalDataSource {}

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
  late MockFriendsRemoteDataSource mockRemoteDataSource;
  late MockFriendsLocalDataSource mockLocalDataSource;
  late MockApiCallHandler mockHandler;
  late FriendsRepository repository;

  setUp(() {
    mockRemoteDataSource = MockFriendsRemoteDataSource();
    mockLocalDataSource = MockFriendsLocalDataSource();
    mockHandler = MockApiCallHandler();
    repository = FriendsRepositoryImpl(
      mockHandler,
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  group('FriendsRepositoryImpl', () {
    const friendModel = FriendModel(
      id: 'user-123',
      name: 'John Doe',
      email: 'john@example.com',
      phone: '123456',
    );

    test('getFriends returns paginated domain Friends', () async {
      when(
        () => mockRemoteDataSource.getFriends(),
      ).thenAnswer(
        (_) async => const FriendsModel(
          data: [friendModel],
          pagination: PaginationModel(hasMore: false),
        ),
      );
      when(
        () => mockLocalDataSource.saveFriends(
          friends: any(named: 'friends'),
          nextCursor: null,
          hasMore: false,
        ),
      ).thenAnswer((_) async {});

      final result = await repository.getFriends();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (paginatedList) {
          expect(paginatedList.items.length, 1);
          expect(paginatedList.items[0].id, 'user-123');
          expect(paginatedList.items[0].name, 'John Doe');
        },
      );
    });

    test('addFriend returns domain Friend', () async {
      when(
        () => mockRemoteDataSource.addFriend(
          friendEmail: 'john@example.com',
          friendPhone: '123456',
        ),
      ).thenAnswer((_) async => friendModel);

      final result = await repository.addFriend(
        friendEmail: 'john@example.com',
        friendPhone: '123456',
      );

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (friend) => expect(friend.id, 'user-123'),
      );
    });

    test('removeFriend returns Unit', () async {
      when(
        () => mockRemoteDataSource.removeFriend('user-123'),
      ).thenAnswer((_) async => unit);

      final result = await repository.removeFriend('user-123');

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (val) => expect(val, unit),
      );
    });
  });
}
