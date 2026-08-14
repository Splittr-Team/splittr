part of 'friends_bloc.dart';

@freezed
class FriendsEvent extends BaseEvent with _$FriendsEvent {
  const FriendsEvent._();

  const factory FriendsEvent.started() = _Started;

  const factory FriendsEvent.friendsFailed({required Failure failure}) =
      _FriendsFailed;

  const factory FriendsEvent.friendsUpdated({required List<Friend> friends}) =
      _FriendsUpdated;

  const factory FriendsEvent.fetchNextPage() = _FetchNextPage;
}
