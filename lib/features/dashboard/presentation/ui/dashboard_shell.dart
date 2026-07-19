import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart'
    show
        AppIconButton,
        AppListTile,
        AppNavigationBar,
        AppNavigationDrawer,
        AppText,
        AppTopBar,
        SkyDesignSystemContextExtension;
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      appBar: AppTopBar(
        title: _resolveTitle(context),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: AppIconButton(
              icon: Icons.notifications_outlined,
              onPressed: () => const NotificationsRoute().push<void>(context),
            ),
          ),
        ],
      ),
      drawer: AppNavigationDrawer(
        selectedIndex: 0,
        onDestinationSelected: (value) {},
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText.headlineMedium(
                  context.strings.appName,
                  color: context.colorScheme.onPrimaryContainer,
                ),
                if (getBloc<AuthBloc>(context).state.user?.email
                    case final String email when email.isNotEmpty)
                  AppText.headlineSmall(
                    email,
                    color: context.colorScheme.onPrimaryContainer,
                  ),
              ],
            ),
          ),
          AppListTile(
            leadingIcon: Icons.logout_rounded,
            title: context.strings.logout,
            onTap: () => getBloc<AuthBloc>(context).loggedOut(),
          ),
        ],
      ),
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: tab.icon,
                selectedIcon: tab.selectedIcon,
                label: tab.getLabel(context),
              ),
            )
            .toList(),
      ),
    );
  }

  static final List<ShellTab> _tabs = [
    ShellTab(
      pathPrefix: DashboardRoute.pathTemplate,
      icon: const Icon(Icons.dashboard_outlined),
      selectedIcon: const Icon(Icons.dashboard),
      getLabel: (context) => context.strings.dashboard,
      defaultRoute: const DashboardRoute(),
    ),
    ShellTab(
      pathPrefix: GroupsRoute.pathTemplate,
      icon: const Icon(Icons.group_outlined),
      selectedIcon: const Icon(Icons.group),
      getLabel: (context) => context.strings.groups,
      defaultRoute: const GroupsRoute(),
    ),
    ShellTab(
      pathPrefix: ProfileRoute.pathTemplate,
      icon: const Icon(Icons.notifications_active_outlined),
      selectedIcon: const Icon(Icons.notifications_active),
      getLabel: (context) => context.strings.activities,
      defaultRoute: const ProfileRoute(),
    ),
  ];

  void _onDestinationSelected(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  String _resolveTitle(BuildContext context) {
    switch (navigationShell.currentIndex) {
      case 1:
        final state = navigationShell.shellRouteContext.routerState;
        if (state.pathParameters case {'groupId': _}) {
          return context.strings.groupDetails;
        }
        return context.strings.myGroups;
      case 2:
        return context.strings.profile;
      default:
        return context.strings.dashboard;
    }
  }
}

class ShellTab {
  const ShellTab({
    required this.pathPrefix,
    required this.icon,
    required this.selectedIcon,
    required this.getLabel,
    required this.defaultRoute,
  });

  final String pathPrefix;
  final Widget icon;
  final Widget selectedIcon;
  final String Function(BuildContext) getLabel;
  final AppRoute defaultRoute;
}
