import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/signup/signup_bloc.dart';

part 'signup_form.dart';

class SignupPage extends BasePage<SignupBloc, SignupState> {
  const SignupPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  SignupBloc createBloc() => getIt<SignupBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return const Scaffold(
      body: _SignupForm(),
    );
  }
}
