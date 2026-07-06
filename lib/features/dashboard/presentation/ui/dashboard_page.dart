
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:splittr/features/dashboard/presentation/ui/tabs/activities_tab.dart';
import 'package:splittr/features/dashboard/presentation/ui/tabs/dashboard_tab.dart';
import 'package:splittr/features/dashboard/presentation/ui/tabs/groups_tab.dart';
import 'package:splittr/utils/bloc_utils/bloc_utils.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'dashboard_form.dart';

class DashboardPage extends BasePage<DashboardBloc, DashboardState> {
  const DashboardPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  DashboardBloc createBloc() => getIt<DashboardBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: const _DashboardForm(),
        appBar: AppBar(
          title: BlocSelector<DashboardBloc, DashboardState, int>(
            selector: (state) => state.store.selectedIndex,
            builder: (context, index) {
              final title = switch (index) {
                0 => context.strings.dashboard,
                1 => context.strings.groups,
                2 => context.strings.activities,
                _ => '',
              };
              return Text(title);
            },
          ),
        ),
        bottomNavigationBar: BlocSelector<DashboardBloc, DashboardState, int>(
          selector: (state) => state.store.selectedIndex,
          builder: (context, selectedIndex) {
            return NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) =>
                  getBloc<DashboardBloc>(context).indexChanged(index),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.dashboard_customize_outlined),
                  selectedIcon: const Icon(Icons.dashboard_customize),
                  label: context.strings.dashboard,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.group_outlined),
                  selectedIcon: const Icon(Icons.group),
                  label: context.strings.groups,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.notifications_active_outlined),
                  selectedIcon: const Icon(Icons.notifications_active),
                  label: context.strings.activities,
                ),
              ],
            );
          },
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Splittr',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().loggedOut();
                },
              ),
            ],
          ),
        ),
      );
  }
}
