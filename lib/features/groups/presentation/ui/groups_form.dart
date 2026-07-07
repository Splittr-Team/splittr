part of 'groups_page.dart';

class _GroupsForm extends StatelessWidget {
  const _GroupsForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        return switch (state) {
          Initial() || ChangeLoaderState() => const Center(
            child: CircularProgressIndicator(),
          ),

          OnFailure(:final failure) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                // Assuming your custom Failure class has a .message property
                failure.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          OnGroupsUpdate() =>
            state.store.groups.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No groups yet. Create one to get started!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.store.groups.length,
                    itemBuilder: (context, index) {
                      final group = state.store.groups[index];
                      return Card(
                        child: ListTile(
                          title: Text(group.name ?? ''),
                          subtitle: Text(group.description ?? ''),
                        ),
                      );
                    },
                  ),
        };
      },
    );
  }
}
