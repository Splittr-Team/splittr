import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/route_paths.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/auth/presentation/blocs/login/login_bloc.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/apple_sign_in_button.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/auth_form_card.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/email_text_field.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/google_sign_in_button.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/or_divider.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/password_text_field.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'login_form.dart';

class LoginPage extends BasePage<LoginBloc, LoginState> {
  const LoginPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  LoginBloc createBloc() => getIt<LoginBloc>()..started(args: args);

  @override
  bool showLoading(LoginState state) => state.store.loading;

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: context.strings.appName,
        centerTitle: true,
        titleColor: context.colorScheme.primary,
      ),
      body: const _LoginForm(),
    );
  }

  @override
  void handleStateChange(BuildContext context, LoginState state) {
    return switch (state) {
      OnFailure(:final failure) => AppSnackBar.show(
        context,
        message: failure.message,
      ),
      _ => () {},
    };
  }
}
