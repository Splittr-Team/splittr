part of 'groups_page.dart';

class _GroupsForm extends StatelessWidget {
  const _GroupsForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        return switch (state) {
          // TODO(Saurabh): Generic error page
          OnFailure(:final failure) => GroupsErrorState(
            message: failure.message,
          ),
          _ =>
            state.store.loading && state.store.groups.isEmpty
                ? const GroupsShimmerList()
                : state.store.groups.isEmpty
                ? const GroupsEmptyState()
                : GroupsListView(
                    groups: state.store.groups,
                    hasMore: state.store.hasMore,
                    isLoadingMore: state.store.loading,
                  ),
        };
      },
    );
  }
}
