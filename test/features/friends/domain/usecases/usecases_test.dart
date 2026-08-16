import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';
import 'package:splittr/features/friends/domain/repositories/friends_repository.dart';
import 'package:splittr/features/friends/domain/usecases/add_friend_usecase.dart';
import 'package:splittr/features/friends/domain/usecases/get_friends_usecase.dart';
import 'package:splittr/features/friends/domain/usecases/remove_friend_usecase.dart';

class MockFriendsRepository extends Mock implements FriendsRepository {}

void main() {
  late MockFriendsRepository mockRepository;
  late GetFriendsUseCase getFriendsUseCase;
  late AddFriendUseCase addFriendUseCase;
  late RemoveFriendUseCase removeFriendUseCase;

  setUp(() {
    mockRepository = MockFriendsRepository();
    getFriendsUseCase = GetFriendsUseCase(mockRepository);
    addFriendUseCase = AddFriendUseCase(mockRepository);
    removeFriendUseCase = RemoveFriendUseCase(mockRepository);
  });

  group('Friends Usecases', () {
    const friend = Friend(
      id: 'user-123',
      name: 'John Doe',
      email: 'john@example.com',
      phone: '123456',
    );

    test('GetFriendsUseCase calls repository.getFriends', () async {
      const expectedList = PaginatedList<Friend>(
        items: [friend],
        pagination: Pagination(hasMore: false),
      );

      when(
        () => mockRepository.getFriends(),
      ).thenAnswer((_) async => const Right(expectedList));

      final result = await getFriendsUseCase.call(const GetFriendsParams());

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (res) => expect(res, expectedList),
      );
      verify(
        () => mockRepository.getFriends(),
      ).called(1);
    });

    test('AddFriendUseCase calls repository.addFriend', () async {
      when(
        () => mockRepository.addFriend(
          friendEmail: 'john@example.com',
          friendPhone: '123456',
        ),
      ).thenAnswer((_) async => const Right(friend));

      final result = await addFriendUseCase.call(
        const AddFriendParams(
          friendEmail: 'john@example.com',
          friendPhone: '123456',
        ),
      );

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (resFriend) => expect(resFriend, friend),
      );
      verify(
        () => mockRepository.addFriend(
          friendEmail: 'john@example.com',
          friendPhone: '123456',
        ),
      ).called(1);
    });

    test('RemoveFriendUseCase calls repository.removeFriend', () async {
      when(
        () => mockRepository.removeFriend('user-123'),
      ).thenAnswer((_) async => const Right(unit));

      final result = await removeFriendUseCase.call(
        const RemoveFriendParams('user-123'),
      );

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (val) => expect(val, unit),
      );
      verify(() => mockRepository.removeFriend('user-123')).called(1);
    });
  });
}
