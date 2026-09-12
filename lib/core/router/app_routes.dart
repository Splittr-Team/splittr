import 'package:flutter/widgets.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/app_config/i_app_config.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/friends/domain/entities/friend.dart';

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

class FriendDetailsRoute extends AppRoute {
  const FriendDetailsRoute({
    required this.friendId,
    this.friend,
  });

  final String friendId;
  final Friend? friend;

  static const String relativePathTemplate = ':friendId';
  static const String pathTemplate = '/friends/:friendId';

  @override
  String get path => '${FriendsRoute.pathTemplate}/$friendId';

  @override
  Object? get extra => friend;

  static FriendDetailsRoute? fromState(GoRouterState state) {
    final friendId = state.pathParameters['friendId'];
    if (friendId == null || friendId.isEmpty) {
      return null;
    }
    final friend = state.extra is Friend ? state.extra! as Friend : null;
    return FriendDetailsRoute(
      friendId: friendId,
      friend: friend,
    );
  }
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

  static const String relativePathTemplate = 'settings';
  static const String pathTemplate = '/groups/:groupId/settings';

  @override
  String get path => '${GroupsRoute.pathTemplate}/$groupId/settings';

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

class ActivitiesRoute extends AppRoute {
  const ActivitiesRoute();

  static const String pathTemplate = '/activities';

  @override
  String get path => pathTemplate;
}

class NotificationsRoute extends AppRoute {
  const NotificationsRoute();

  static const String pathTemplate = '/notifications';

  @override
  String get path => pathTemplate;
}

class AddExpenseArgs {
  const AddExpenseArgs({
    this.expense,
    this.groupId,
    this.friendId,
    this.participantUserIds = const [],
  });

  final Expense? expense;
  final String? groupId;
  final String? friendId;
  final List<String> participantUserIds;
}

class AddExpenseRoute extends AppRoute {
  const AddExpenseRoute({this.args});

  final AddExpenseArgs? args;

  static const String pathTemplate = '/expenses/add';

  @override
  String get path => pathTemplate;

  @override
  Object? get extra => args;

  static AddExpenseRoute? fromState(GoRouterState state) {
    if (state.extra case final AddExpenseArgs args) {
      return AddExpenseRoute(args: args);
    }
    final groupId = state.uri.queryParameters['groupId'];
    final friendId = state.uri.queryParameters['friendId'];
    return AddExpenseRoute(
      args: AddExpenseArgs(groupId: groupId, friendId: friendId),
    );
  }
}

class ExpenseDetailsRoute extends AppRoute {
  const ExpenseDetailsRoute({
    required this.expenseId,
    this.expense,
  });

  final String expenseId;
  final Expense? expense;

  static const String pathTemplate = '/expenses/:expenseId';

  @override
  String get path => '/expenses/$expenseId';

  @override
  Object? get extra => expense;

  static ExpenseDetailsRoute? fromState(GoRouterState state) {
    final expenseId = state.pathParameters['expenseId'];
    if (expenseId == null || expenseId.isEmpty) {
      return null;
    }
    final extra = state.extra;
    final expense = extra is Expense ? extra : null;
    return ExpenseDetailsRoute(expenseId: expenseId, expense: expense);
  }
}

class SettleUpArgs {
  const SettleUpArgs({
    this.groupId,
    this.payerId,
    this.receiverId,
    this.payerName,
    this.receiverName,
    this.amount,
    this.currency,
  });

  final String? groupId;
  final String? payerId;
  final String? receiverId;
  final String? payerName;
  final String? receiverName;
  final num? amount;
  final String? currency;
}

class SettleUpRoute extends AppRoute {
  const SettleUpRoute({this.args});

  final SettleUpArgs? args;

  static const String pathTemplate = '/expenses/settle';

  @override
  String get path => pathTemplate;

  @override
  Object? get extra => args;

  static SettleUpRoute? fromState(GoRouterState state) {
    if (state.extra case final SettleUpArgs args) {
      return SettleUpRoute(args: args);
    }
    final groupId = state.uri.queryParameters['groupId'];
    final payerId = state.uri.queryParameters['payerId'];
    final receiverId = state.uri.queryParameters['receiverId'];
    final amountStr = state.uri.queryParameters['amount'];
    final amount = amountStr != null ? num.tryParse(amountStr) : null;
    final currency = state.uri.queryParameters['currency'];

    return SettleUpRoute(
      args: SettleUpArgs(
        groupId: groupId,
        payerId: payerId,
        receiverId: receiverId,
        amount: amount,
        currency: currency,
      ),
    );
  }
}
