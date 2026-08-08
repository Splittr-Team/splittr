part of 'friends_page.dart';

class _FriendsForm extends StatelessWidget {
  const _FriendsForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (context, state) {
        return switch (state) {
          OnFailure(:final failure) => FriendsErrorState(
            message: failure.message,
          ),
          _ =>
            state.store.loading && state.store.friends.isEmpty
                ? const FriendsShimmerList()
                : AppRefreshIndicator(
                    onRefresh: () async {
                      getBloc<FriendsBloc>(context).started(noParams);
                    },
                    child: state.store.friends.isEmpty
                        ? const Center(child: FriendsEmptyState())
                        : FriendsListView(
                            friends: state.store.friends,
                            hasMore: state.store.hasMore,
                            isLoadingMore: state.store.loading,
                          ),
                  ),
        };
      },
    );
  }
}
