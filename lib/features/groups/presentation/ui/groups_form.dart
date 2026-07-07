part of 'groups_page.dart';

class _GroupsForm extends StatelessWidget {
  const _GroupsForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        return switch (state) {
          Initial() || Loading() => const Center(
            child: CircularProgressIndicator(),
          ),
          Error(:final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Loaded(:final groups) =>
            groups.isEmpty
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
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
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
