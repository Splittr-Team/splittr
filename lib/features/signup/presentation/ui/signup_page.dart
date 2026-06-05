import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' hide AppColors;
import 'package:splittr/core/route_handler/route_handler.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/signup/presentation/blocs/signup_bloc.dart';

part 'signup_form.dart';

class SignupPage extends BasePage<SignupBloc, SignupState> {
  const SignupPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  SignupBloc createBloc() => getIt<SignupBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return const Scaffold(body: _SignupForm());
  }
}
