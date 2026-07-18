part of 'groups_page.dart';

class _GroupsForm extends StatelessWidget {
  const _GroupsForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        if (state.store.loading && state.store.groups.isEmpty) {
          return const GroupsShimmerList();
        }
        return switch (state) {
          OnFailure(:final failure) => GroupsErrorState(
            message: failure.message,
          ),

          OnGroupsUpdate() =>
            state.store.groups.isEmpty && !state.store.loading
                ? const GroupsEmptyState()
                : GroupsListView(groups: state.store.groups),
          (_) => const SizedBox(),
        };
      },
    );
  }
}
