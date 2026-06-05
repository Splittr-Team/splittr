import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' hide AppColors;
import 'package:splittr/constants/animations/animation_keys.dart';
import 'package:splittr/core/route_handler/route_handler.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth_landing/presentation/blocs/auth_landing_bloc.dart';

part 'auth_landing_form.dart';

class AuthLandingPage extends BasePage<AuthLandingBloc, AuthLandingState> {
  const AuthLandingPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  AuthLandingBloc createBloc() => getIt<AuthLandingBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return const Scaffold(
      body: _AuthLandingForm(),
    );
  }
}
