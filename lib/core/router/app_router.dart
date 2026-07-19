import 'package:flutter/material.dart';
import 'package:sky_router/sky_router.dart';
import 'package:sky_telemetry/sky_telemetry.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/core/router/route_error_page.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/features/auth/presentation/pages/login/login_page.dart';
import 'package:splittr/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:splittr/features/dashboard/presentation/ui/animated_branch_container.dart';
import 'package:splittr/features/dashboard/presentation/ui/dashboard_page.dart';
import 'package:splittr/features/dashboard/presentation/ui/dashboard_shell.dart';
import 'package:splittr/features/groups/presentation/ui/group_details/group_details_page.dart';
import 'package:splittr/features/groups/presentation/ui/groups_page.dart';
import 'package:splittr/features/groups/presentation/ui/join_group_page.dart';
import 'package:splittr/features/notifications/presentation/ui/notifications_page.dart';
import 'package:splittr/features/profile/presentation/ui/profile_page.dart';
import 'package:splittr/features/quick_settle/presentation/ui/quick_settle_page.dart';
import 'package:splittr/features/quick_split/presentation/ui/quick_split_page.dart';
import 'package:splittr/features/quick_split/presentation/ui/split_history_page.dart';
import 'package:splittr/features/splash/presentation/ui/splash_page.dart';

/// Routes that do not require authentication.
const List<String> _publicRoutes = [
  SplashRoute.pathTemplate,
  LoginRoute.pathTemplate,
  SignUpRoute.pathTemplate,
];

/// Routes accessible only by guest users.
const List<String> _guestRoutes = [
  QuickSplitRoute.pathTemplate,
  QuickSettleRoute.pathTemplate,
  SplitHistoryRoute.pathTemplate,
];

/// Root navigator key for the application.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Creates and configures the application's [GoRouter] instance.
GoRouter createAppRouter({
  required AuthBloc authBloc,
  required AppLogger logger,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: SplashRoute.pathTemplate,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    observers: [
      CustomNavigatorObserver(logger: logger),
    ],
    redirect: (context, state) => _redirect(authBloc, state),
    routes: _routes,
    errorBuilder: (context, state) {
      final errorMsg =
          state.error?.message ?? state.error?.toString() ?? 'Page not found.';
      return RouteErrorPage(
        errorMessage: errorMsg
            .replaceFirst('Exception: ', '')
            .replaceFirst('GoException: ', ''),
      );
    },
  );
}

/// Redirect logic based on the current [AuthBloc] state.
String? _redirect(AuthBloc authBloc, GoRouterState state) {
  final authState = authBloc.state;
  final currentLocation = state.matchedLocation;

  // During initial state (splash screen is resolving), do not redirect.
  if (authState case Loading _) return null;

  final isOnPublicRoute = _publicRoutes.contains(currentLocation);
  final isOnSplash = currentLocation == SplashRoute.pathTemplate;

  // User is authenticated.
  if (authState case OnUserAuthenticated _) {
    if (isOnPublicRoute) {
      final redirectTarget = LoginRoute.fromState(state)?.redirect;
      if (redirectTarget != null) {
        return Uri.decodeComponent(redirectTarget);
      }
      return const DashboardRoute().path;
    }
    return null;
  }

  // User is a guest (unauthenticated but using app in guest mode).
  if (authState is Guest) {
    if (isOnPublicRoute) return const SplitHistoryRoute().path;

    final isOnGuestRoute = _guestRoutes.contains(currentLocation);
    if (!isOnGuestRoute) return const SplitHistoryRoute().path;

    return null;
  }

  // User is unauthenticated or logged out.
  if (authState is OnUserUnauthenticated || authState is OnLogout) {
    if (isOnPublicRoute) {
      if (isOnSplash) return LoginRoute.pathTemplate;
      return null;
    }
    final target = state.uri.toString();
    return LoginRoute(redirect: target).path;
  }

  return null;
}

final List<RouteBase> _routes = [
  GoRoute(
    path: SplashRoute.pathTemplate,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: LoginRoute.pathTemplate,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: SignUpRoute.pathTemplate,
    builder: (context, state) => const SignUpPage(),
  ),
  StatefulShellRoute(
    builder: (context, state, navigationShell) => DashboardShell(
      navigationShell: navigationShell,
    ),
    navigatorContainerBuilder: (context, navigationShell, children) =>
        AnimatedBranchContainer(
          currentIndex: navigationShell.currentIndex,
          children: children,
        ),
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: DashboardRoute.pathTemplate,
            builder: (context, state) => const _TabBackRedirectGuard(
              isDashboard: true,
              child: DashboardPage(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: GroupsRoute.pathTemplate,
            builder: (context, state) => const _TabBackRedirectGuard(
              child: GroupsPage(),
            ),
            routes: [
              GoRoute(
                path: GroupDetailsRoute.relativePathTemplate,
                builder: (context, state) {
                  final route = GroupDetailsRoute.fromState(state);

                  if (route == null) {
                    throw GoException('Invalid or missing group identifier.');
                  }

                  return GroupDetailsPage(
                    groupId: route.groupId,
                    group: route.group,
                  );
                },
              ),
              GoRoute(
                path: JoinGroupRoute.relativePathTemplate,
                builder: (context, state) {
                  final route = JoinGroupRoute.fromState(state);

                  if (route == null) {
                    throw GoException('Invalid or missing invite code.');
                  }

                  return JoinGroupPage(inviteCode: route.code);
                },
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: ProfileRoute.pathTemplate,
            builder: (context, state) => const _TabBackRedirectGuard(
              child: ProfilePage(),
            ),
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: QuickSettleRoute.pathTemplate,
    builder: (context, state) {
      final route = QuickSettleRoute.fromState(state);

      if (route == null) {
        throw GoException('Invalid or missing settlement arguments.');
      }

      return QuickSettlePage(args: route.args);
    },
  ),
  GoRoute(
    path: QuickSplitRoute.pathTemplate,
    builder: (context, state) => const QuickSplitPage(),
  ),
  GoRoute(
    path: SplitHistoryRoute.pathTemplate,
    builder: (context, state) => const SplitHistoryPage(),
  ),
  GoRoute(
    path: NotificationsRoute.pathTemplate,
    builder: (context, state) => const NotificationsPage(),
  ),
];

class _TabBackRedirectGuard extends StatelessWidget {
  const _TabBackRedirectGuard({
    required this.child,
    this.isDashboard = false,
  });

  final Widget child;
  final bool isDashboard;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isDashboard,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        const DashboardRoute().go(context);
      },
      child: child,
    );
  }
}
