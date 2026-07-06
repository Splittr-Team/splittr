import 'package:flutter/material.dart';
import 'package:sky_router/sky_router.dart';
import 'package:sky_telemetry/sky_telemetry.dart';
import 'package:splittr/core/router/route_paths.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/features/auth/presentation/pages/login/login_page.dart';
import 'package:splittr/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:splittr/features/dashboard/presentation/ui/dashboard_page.dart';
import 'package:splittr/features/dashboard/presentation/ui/dashboard_shell.dart';
import 'package:splittr/features/group_dashboard/presentation/ui/group_dashboard_page.dart';
import 'package:splittr/features/groups/presentation/ui/groups_page.dart';
import 'package:splittr/features/profile/presentation/ui/profile_page.dart';
import 'package:splittr/features/quick_settle/presentation/ui/quick_settle_page.dart';
import 'package:splittr/features/quick_split/presentation/ui/quick_split_page.dart';
import 'package:splittr/features/quick_split/presentation/ui/split_history_page.dart';
import 'package:splittr/features/splash/presentation/ui/splash_page.dart';

/// Routes that do not require authentication.
const List<String> _publicRoutes = [
  RoutePaths.splash,
  RoutePaths.login,
  RoutePaths.signUp,
];

/// Routes accessible only by guest users.
const List<String> _guestRoutes = [
  RoutePaths.quickSplit,
  RoutePaths.quickSettle,
  RoutePaths.splitHistory,
];

/// Creates and configures the application's [GoRouter] instance.
///
/// The [authBloc] is used for both:
/// - Creating a [GoRouterRefreshStream] to trigger route re-evaluation
///   when the authentication state changes.
/// - Evaluating the current auth state inside the redirect callback.
GoRouter createAppRouter({
  required AuthBloc authBloc,
  required AppLogger logger,
}) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    observers: [
      CustomNavigatorObserver(logger: logger),
    ],
    redirect: (context, state) => _redirect(authBloc, state),
    routes: _routes,
  );
}

/// Redirect logic based on the current [AuthBloc] state.
///
/// - During splash (initial state), no redirect happens — the splash screen
///   handles its own 3-second delay and triggers auth check.
/// - Once auth resolves:
///   - Authenticated → redirect auth pages to `/dashboard`.
///   - Guest → redirect auth pages to `/split-history`.
///   - Unauthenticated/Logout → redirect protected pages to `/login`.
String? _redirect(AuthBloc authBloc, GoRouterState state) {
  final authState = authBloc.state;
  final currentLocation = state.matchedLocation;

  // During initial state (splash screen is resolving), do not redirect.
  // Let the SplashPage handle its animation and auth check flow.
  if (authState is Initial) return null;

  final isOnPublicRoute = _publicRoutes.contains(currentLocation);
  final isOnSplash = currentLocation == RoutePaths.splash;

  // User is authenticated.
  if (authState is Authenticated) {
    // If on a public route (splash/login/signUp), redirect to dashboard.
    if (isOnPublicRoute) return RoutePaths.dashboard;
    return null;
  }

  // User is a guest (unauthenticated but using app in guest mode).
  if (authState is Guest) {
    // If on a public route, redirect to split history.
    if (isOnPublicRoute) return RoutePaths.splitHistory;

    // Guest users can only access guest routes.
    final isOnGuestRoute = _guestRoutes.contains(currentLocation);
    if (!isOnGuestRoute) return RoutePaths.splitHistory;

    return null;
  }

  // User is unauthenticated or logged out.
  if (authState is OnUserUnauthenticated || authState is OnLogout) {
    // If already on a public route, stay there.
    if (isOnPublicRoute) {
      // But if on splash, redirect to login.
      if (isOnSplash) return RoutePaths.login;
      return null;
    }
    // Redirect any protected route to login.
    return RoutePaths.login;
  }

  return null;
}

final List<RouteBase> _routes = [
  GoRoute(
    path: RoutePaths.splash,
    builder: (context, state) =>
        SplashPage(args: state.extra as Map<String, dynamic>?),
  ),
  GoRoute(
    path: RoutePaths.login,
    builder: (context, state) =>
        LoginPage(args: state.extra as Map<String, dynamic>?),
  ),
  GoRoute(
    path: RoutePaths.signUp,
    builder: (context, state) =>
        SignUpPage(args: state.extra as Map<String, dynamic>?),
  ),
  ShellRoute(
    builder: (context, state, child) => DashboardShell(
      currentLocation: state.matchedLocation,
      child: child,
    ),
    routes: [
      GoRoute(
        path: RoutePaths.dashboard,
        pageBuilder: (context, state) => ShellTransitionPage<void>(
          key: state.pageKey,
          targetIndex: 0,
          child: _TabBackRedirectGuard(
            isDashboard: true,
            child: DashboardPage(args: state.extra as Map<String, dynamic>?),
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.groups,
        pageBuilder: (context, state) => ShellTransitionPage<void>(
          key: state.pageKey,
          targetIndex: 1,
          child: const _TabBackRedirectGuard(
            child: GroupsPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.profile,
        pageBuilder: (context, state) => ShellTransitionPage<void>(
          key: state.pageKey,
          targetIndex: 2,
          child: _TabBackRedirectGuard(
            child: ProfilePage(args: state.extra as Map<String, dynamic>?),
          ),
        ),
      ),
    ],
  ),
  GoRoute(
    path: RoutePaths.groupDashboard,
    builder: (context, state) {
      final groupId = state.pathParameters['groupId'];
      final args = (state.extra as Map<String, dynamic>?) ?? {};
      return GroupDashboardPage(args: {'groupId': groupId, ...args});
    },
  ),
  GoRoute(
    path: RoutePaths.quickSettle,
    builder: (context, state) =>
        QuickSettlePage(args: state.extra as Map<String, dynamic>?),
  ),
  GoRoute(
    path: RoutePaths.quickSplit,
    builder: (context, state) =>
        QuickSplitPage(args: state.extra as Map<String, dynamic>?),
  ),
  GoRoute(
    path: RoutePaths.splitHistory,
    builder: (context, state) =>
        SplitHistoryPage(args: state.extra as Map<String, dynamic>?),
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
        RouteHandler.go(context, RoutePaths.dashboard);
      },
      child: child,
    );
  }
}

int _lastTabIndex = 0;

class ShellTransitionPage<T> extends CustomTransitionPage<T> {
  ShellTransitionPage({
    required int targetIndex,
    required super.child,
    required super.key,
  }) : super(
         transitionDuration: const Duration(milliseconds: 250),
         reverseTransitionDuration: const Duration(milliseconds: 250),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final movingForward = targetIndex > _lastTabIndex;
           final beginOffset = movingForward
               ? const Offset(1, 0)
               : const Offset(-1, 0);

           _lastTabIndex = targetIndex;

           return SlideTransition(
             position: animation.drive(
               Tween<Offset>(
                 begin: beginOffset,
                 end: Offset.zero,
               ).chain(CurveTween(curve: Curves.easeOutBack)),
             ),
             child: SlideTransition(
               position: secondaryAnimation.drive(
                 Tween<Offset>(
                   begin: Offset.zero,
                   end: -beginOffset,
                 ).chain(CurveTween(curve: Curves.easeOutBack)),
               ),
               child: child,
             ),
           );
         },
       );
}
