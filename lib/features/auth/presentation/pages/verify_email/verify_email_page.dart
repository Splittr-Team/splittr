import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'verify_email_form.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: context.strings.appName,
        centerTitle: true,
        titleColor: context.colorScheme.primary,
      ),
      body: const _VerifyEmailForm(),
    );
  }
}
