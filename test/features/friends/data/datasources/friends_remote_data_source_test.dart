import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination_model.dart';
import 'package:splittr/features/auth/data/models/user_model.dart';
import 'package:splittr/features/friends/data/datasources/friends_api_client.dart';
import 'package:splittr/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:splittr/features/friends/data/datasources/friends_remote_data_source_impl.dart';
import 'package:splittr/features/friends/data/models/add_friend_payload.dart';
import 'package:splittr/features/friends/data/models/friends_response_model.dart';

class MockFriendsApiClient extends Mock implements FriendsApiClient {}

void main() {
  late MockFriendsApiClient mockApiClient;
  late FriendsRemoteDataSource dataSource;

  setUp(() {
    mockApiClient = MockFriendsApiClient();
    dataSource = FriendsRemoteDataSourceImpl(mockApiClient);
    registerFallbackValue(const AddFriendPayload());
  });

  group('FriendsRemoteDataSource', () {
    const userModel = UserModel(
      id: 'user-123',
      firebaseUid: 'fb-123',
      name: 'John Doe',
      email: 'john@example.com',
      phone: '123456',
    );

    test('getFriends calls apiClient.getFriends', () async {
      const responseModel = FriendsResponseModel(
        data: [userModel],
        pagination: PaginationModel(hasMore: false),
      );

      when(
        () => mockApiClient.getFriends(),
      ).thenAnswer((_) async => responseModel);

      final result = await dataSource.getFriends();

      expect(result, responseModel);
      verify(() => mockApiClient.getFriends()).called(1);
    });

    test('addFriend calls apiClient.addFriend with payload', () async {
      when(
        () => mockApiClient.addFriend(any()),
      ).thenAnswer((_) async => userModel);

      final result = await dataSource.addFriend(
        friendEmail: 'john@example.com',
        friendPhone: '123456',
      );

      expect(result, userModel);
      verify(
        () => mockApiClient.addFriend(
          any(
            that: isA<AddFriendPayload>()
                .having((p) => p.friendEmail, 'friendEmail', 'john@example.com')
                .having((p) => p.friendPhone, 'friendPhone', '123456'),
          ),
        ),
      ).called(1);
    });

    test('removeFriend calls apiClient.removeFriend', () async {
      when(
        () => mockApiClient.removeFriend('user-123'),
      ).thenAnswer((_) async {});

      final result = await dataSource.removeFriend('user-123');

      expect(result, unit);
      verify(() => mockApiClient.removeFriend('user-123')).called(1);
    });
  });
}
