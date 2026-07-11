import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart' hide State;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/sign_up/sign_up_bloc.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/apple_sign_in_button.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/auth_form_card.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/confirm_password_text_field.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/email_text_field.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/google_sign_in_button.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/name_text_field.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/or_divider.dart';
import 'package:splittr/features/auth/presentation/pages/widgets/password_text_field.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

part 'sign_up_form.dart';

class SignUpPage extends BasePage<SignUpBloc, SignUpState> {
  const SignUpPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  SignUpBloc createBloc() => getIt<SignUpBloc>()..started(args: args);

  @override
  bool showLoading(SignUpState state) => state.store.loading;

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: context.strings.appName,
        centerTitle: true,
        titleColor: context.colorScheme.primary,
      ),
      body: const _SignUpForm(),
    );
  }

  @override
  void handleStateChange(BuildContext context, SignUpState state) {
    return switch (state) {
      OnSignUpSuccess _ => AppSnackBar.show(
        context,
        message: context.strings.signUpSuccess,
      ),
      OnFailure _ => AppSnackBar.show(context, message: state.failure.message),
      _ => () {},
    };
  }
}
