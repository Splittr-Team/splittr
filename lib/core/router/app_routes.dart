import 'package:flutter/widgets.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/app_config/i_app_config.dart';

sealed class AppRoute {
  const AppRoute();

  String get path;

  Object? get extra => null;

  void go(BuildContext context) {
    RouteHandler.go(context, path, extra: extra);
  }

  Future<T?> push<T>(BuildContext context) {
    return RouteHandler.push<T>(context, path, extra: extra);
  }

  void pushReplacement(BuildContext context) {
    RouteHandler.pushReplacement(context, path, extra: extra);
  }

  void pushAndRemoveUntil(BuildContext context) {
    RouteHandler.pushAndRemoveUntil(context, path, extra: extra);
  }
}

class SplashRoute extends AppRoute {
  const SplashRoute();

  static const String pathTemplate = '/';

  @override
  String get path => pathTemplate;
}

class ForceUpdateRoute extends AppRoute {
  const ForceUpdateRoute();

  static const String pathTemplate = '/force-update';

  @override
  String get path => pathTemplate;
}

class MaintenanceRoute extends AppRoute {
  const MaintenanceRoute();

  static const String pathTemplate = '/maintenance';

  @override
  String get path => pathTemplate;
}

class LoginRoute extends AppRoute {
  const LoginRoute({this.redirect});

  final String? redirect;

  static const String pathTemplate = '/login';

  @override
  String get path {
    if (redirect != null) {
      return Uri(
        path: pathTemplate,
        queryParameters: {'redirect': redirect},
      ).toString();
    }
    return pathTemplate;
  }

  static LoginRoute? fromState(GoRouterState state) {
    final redirect = state.uri.queryParameters['redirect'];
    return LoginRoute(redirect: redirect);
  }
}

class SignUpRoute extends AppRoute {
  const SignUpRoute();

  static const String pathTemplate = '/sign-up';

  @override
  String get path => pathTemplate;
}

class DashboardRoute extends AppRoute {
  const DashboardRoute();

  static const String pathTemplate = '/dashboard';

  @override
  String get path => pathTemplate;
}

class GroupsRoute extends AppRoute {
  const GroupsRoute();

  static const String pathTemplate = '/groups';

  @override
  String get path => pathTemplate;
}

class FriendsRoute extends AppRoute {
  const FriendsRoute();

  static const String pathTemplate = '/friends';

  @override
  String get path => pathTemplate;
}

class GroupRoute extends AppRoute {
  const GroupRoute({required this.groupId});

  final String groupId;

  static const String relativePathTemplate = ':groupId';

  @override
  String get path => '${GroupsRoute.pathTemplate}/$groupId';

  static GroupRoute? fromState(GoRouterState state) {
    final groupId = state.pathParameters['groupId'];
    if (groupId == null || groupId.isEmpty) {
      return null;
    }
    return GroupRoute(groupId: groupId);
  }
}

class AddMembersRoute extends AppRoute {
  const AddMembersRoute({required this.groupId});

  final String groupId;

  static const String relativePathTemplate = 'add-members';
  static const String pathTemplate = '/groups/:groupId/add-members';

  @override
  String get path => '${GroupsRoute.pathTemplate}/$groupId/add-members';

  static AddMembersRoute? fromState(GoRouterState state) {
    final groupId = state.pathParameters['groupId'];
    if (groupId == null || groupId.isEmpty) {
      return null;
    }
    return AddMembersRoute(groupId: groupId);
  }
}

class GroupSettingsRoute extends AppRoute {
  const GroupSettingsRoute({required this.groupId});

  final String groupId;

  static const String relativePathTemplate = 'group-settings';
  static const String pathTemplate = '/groups/:groupId/group-settings';

  @override
  String get path => '${GroupsRoute.pathTemplate}/$groupId/group-settings';

  static GroupSettingsRoute? fromState(GoRouterState state) {
    final groupId = state.pathParameters['groupId'];
    if (groupId == null || groupId.isEmpty) {
      return null;
    }
    return GroupSettingsRoute(groupId: groupId);
  }
}

class JoinGroupRoute extends AppRoute {
  const JoinGroupRoute(this.code);

  final String code;

  static const String relativePathTemplate = 'join/:code';

  @override
  String get path => '${GroupsRoute.pathTemplate}/join/$code';

  static JoinGroupRoute? fromState(GoRouterState state) {
    final code = state.pathParameters['code'];
    if (code == null || code.isEmpty) {
      return null;
    }
    return JoinGroupRoute(code);
  }

  String toDeepLink() {
    final baseUri = Uri.parse(appConfig.deeplinkBaseUrl);
    return baseUri.replace(path: path).toString();
  }
}

class ProfileRoute extends AppRoute {
  const ProfileRoute();

  static const String pathTemplate = '/profile';

  @override
  String get path => pathTemplate;
}

class QuickSettleArgs {
  const QuickSettleArgs({
    required this.splitTitle,
    required this.peopleRecords,
  });

  final String splitTitle;
  final List<({num amount, String name})> peopleRecords;
}

class QuickSettleRoute extends AppRoute {
  const QuickSettleRoute(this.args);

  final QuickSettleArgs args;

  static const String pathTemplate = '/quick-settle';

  @override
  String get path => pathTemplate;

  @override
  Object? get extra => args;

  static QuickSettleRoute? fromState(GoRouterState state) {
    if (state.extra case final QuickSettleArgs args) {
      return QuickSettleRoute(args);
    }

    return null;
  }
}

class QuickSplitRoute extends AppRoute {
  const QuickSplitRoute();

  static const String pathTemplate = '/quick-split';

  @override
  String get path => pathTemplate;
}

class SplitHistoryRoute extends AppRoute {
  const SplitHistoryRoute();

  static const String pathTemplate = '/split-history';

  @override
  String get path => pathTemplate;
}

class NotificationsRoute extends AppRoute {
  const NotificationsRoute();

  static const String pathTemplate = '/notifications';

  @override
  String get path => pathTemplate;
}
