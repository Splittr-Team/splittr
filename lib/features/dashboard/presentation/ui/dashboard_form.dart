part of 'dashboard_page.dart';

class _DashboardForm extends StatelessWidget {
  const _DashboardForm();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DashboardBloc, DashboardState, int>(
      selector: (state) => state.store.selectedIndex,
      builder: (context, selectedIndex) {
        return IndexedStack(
          index: selectedIndex,
          children: const [
            DashboardTab(),
            GroupsTab(),
            ActivitiesTab(),
          ],
        );
      },
    );
  }
}
