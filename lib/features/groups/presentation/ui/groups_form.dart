part of 'groups_page.dart';

class _GroupsForm extends StatelessWidget {
  const _GroupsForm();

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: () async {
        getBloc<GroupsBloc>(context).started(noParams);
      },
      child: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          return switch (state) {
            OnFailure(:final failure) => AppErrorState(
              failure: failure,
              onRetry: () => getBloc<GroupsBloc>(context).started(noParams),
            ),
            _ =>
              state.store.loading && state.store.groups.isEmpty
                  ? const GroupsShimmerList()
                  : state.store.groups.isEmpty
                  ? AppEmptyState(
                      icon: Icons.group_off_outlined,
                      title: context.strings.noGroupsYet,
                      subtitle: context.strings.createGroupEmptyStateSubtitle,
                    )
                  : GroupsListView(
                      groups: state.store.groups,
                      hasMore: state.store.hasMore,
                      isLoadingMore: state.store.loading,
                    ),
          };
        },
      ),
    );
  }
}
