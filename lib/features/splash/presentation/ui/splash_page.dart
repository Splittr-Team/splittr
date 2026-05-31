import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:splittr/constants/constants.dart';
import 'package:splittr/core/base/base_page/base_page.dart';
import 'package:splittr/core/global/presentation/blocs/global_bloc.dart';
import 'package:splittr/core/route_handler/route_handler.dart';
import 'package:splittr/core/user/domain/models/user.dart';
import 'package:splittr/features/splash/presentation/blocs/splash_bloc.dart';
import 'package:splittr/utils/bloc_utils/bloc_utils.dart';

part 'splash_form.dart';

class SplashPage extends BasePage<SplashBloc> {
  const SplashPage({required super.args, super.key});

  @override
  bool get showFullScreenLoader => false;

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: _handleState,
        child: const _SplashForm(),
      ),
    );
  }

  void _handleState(BuildContext context, SplashState state) {
    return switch (state) {
      UserAuthorized(:final user) => _userAuthorized(
        context: context,
        user: user,
      ),
      UserUnauthorized _ => _navigateToAuthLandingPage(context),
      _ => () {},
    };
  }

  void _userAuthorized({required BuildContext context, required User user}) {
    getBloc<GlobalBloc>(context).userUpdated(user);

    _navigateToDashboardPage(context);
  }

  void _navigateToDashboardPage(BuildContext context) {
    unawaited(RouteHandler.pushReplacement(context, RouteId.dashboard));
  }

  void _navigateToAuthLandingPage(BuildContext context) {
    unawaited(RouteHandler.pushReplacement(context, RouteId.authLanding));
  }
}
