/// Centralized route path definitions for the Splittr app.
///
/// These constants define the URL paths used by GoRouter.
/// Deep-linkable routes use descriptive URL segments.
final class RoutePaths {
  const RoutePaths._();

  static const splash = '/';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const dashboard = '/dashboard';
  static const groups = '/groups';
  static const profile = '/profile';
  static const groupDashboard = '/group-dashboard/:groupId';
  static const quickSettle = '/quick-settle';
  static const quickSplit = '/quick-split';
  static const splitHistory = '/split-history';

  /// Generates a group dashboard path with a specific [groupId].
  static String groupDashboardPath(String groupId) =>
      '/group-dashboard/$groupId';
}
