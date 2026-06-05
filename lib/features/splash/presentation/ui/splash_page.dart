import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppImage;
import 'package:splittr/constants/constants.dart';
import 'package:splittr/core/route_handler/route_handler.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/features/splash/presentation/blocs/splash_bloc.dart';
import 'package:splittr/utils/bloc_utils/bloc_utils.dart';

part 'splash_form.dart';

class SplashPage extends BasePage<SplashBloc, SplashState> {
  const SplashPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  SplashBloc createBloc() => getIt<SplashBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        return switch (state) {
          OnUserAuthenticated _ => getBloc<SplashBloc>(
            context,
          ).userAuthorized(),
          OnUserUnauthenticated _ => getBloc<SplashBloc>(
            context,
          ).userUnauthorized(),
          _ => () {},
        };
      },
      child: const Scaffold(
        body: _SplashForm(),
      ),
    );
  }

  @override
  void handleStateChange(BuildContext context, SplashState state) {
    return switch (state) {
      OnCheckAuthStatus _ => getBloc<AuthBloc>(context).authStatusChecked(),
      OnUserAuthorize _ => _userAuthorized(context: context),
      OnUserUnauthorize _ => _navigateToAuthLandingPage(context),
      _ => () {},
    };
  }

  void _userAuthorized({required BuildContext context}) {
    _navigateToDashboardPage(context);
  }

  void _navigateToDashboardPage(BuildContext context) {
    unawaited(RouteHandler.pushReplacement(context, RouteId.dashboard));
  }

  void _navigateToAuthLandingPage(BuildContext context) {
    unawaited(RouteHandler.pushReplacement(context, RouteId.login));
  }
}
