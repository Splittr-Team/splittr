import 'package:flutter/material.dart';
import 'package:sky_utils/sky_utils.dart';
import 'package:splittr/core/route_handler/route_id.dart';
import 'package:splittr/features/auth/presentation/pages/login/login_page.dart';
import 'package:splittr/features/dashboard/presentation/ui/dashboard_page.dart';
import 'package:splittr/features/group_dashboard/presentation/ui/group_dashboard_page.dart';
import 'package:splittr/features/profile/presentation/ui/profile_page.dart';
import 'package:splittr/features/quick_settle/presentation/ui/quick_settle_page.dart';
import 'package:splittr/features/quick_split/presentation/ui/quick_split_page.dart';
import 'package:splittr/features/signup/presentation/ui/signup_page.dart';
import 'package:splittr/features/splash/presentation/ui/splash_page.dart';

export 'route_id.dart';

final class RouteHandler {
  const RouteHandler._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeId = RouteId.values.byNameOrNull(settings.name);

    if (routeId == null) {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('Invalid Route ${settings.name}')),
        ),
      );
    }

    final args = settings.arguments as Map<String, dynamic>?;

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => switch (routeId) {
        RouteId.splash => SplashPage(args: args),
        RouteId.dashboard => DashboardPage(args: args),
        RouteId.login => LoginPage(args: args),
        RouteId.signup => SignupPage(args: args),
        RouteId.profile => ProfilePage(args: args),
        RouteId.groupDashboard => GroupDashboardPage(args: args),
        RouteId.quickSettle => QuickSettlePage(args: args),
        RouteId.quickSplit => QuickSplitPage(args: args),
      },
    );
  }

  static Future<Map<String, dynamic>?> push(
    BuildContext context,
    RouteId routeId, {
    Map<String, dynamic>? args,
  }) async {
    final returnedArgs = await Navigator.pushNamed(
      context,
      routeId.name,
      arguments: args,
    );

    return returnedArgs as Map<String, dynamic>?;
  }

  static Future<Map<String, dynamic>?> pushReplacement(
    BuildContext context,
    RouteId routeId, {
    Map<String, dynamic>? args,
  }) async {
    final returnedArgs = await Navigator.pushReplacementNamed(
      context,
      routeId.name,
      arguments: args,
    );

    return returnedArgs as Map<String, dynamic>?;
  }

  static Future<Map<String, dynamic>?> pushAndRemoveUntil(
    BuildContext context,
    RouteId routeId, {
    bool Function(Route<dynamic>)? predicate,
    Map<String, dynamic>? args,
  }) async {
    final returnedArgs = await Navigator.pushNamedAndRemoveUntil(
      context,
      routeId.name,
      predicate ?? (_) => false,
      arguments: args,
    );

    return returnedArgs as Map<String, dynamic>?;
  }

  static void pop(BuildContext context, {Map<String, dynamic>? args}) {
    Navigator.pop(context, args);
  }
}
