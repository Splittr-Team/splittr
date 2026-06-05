import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart'
    show AppButton, AppScrollView, AppSliverScrollView, AppTextField, AppTopBar;
import 'package:splittr/core/app_config/i_app_config.dart';

part 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: appConfig.appName,
        centerTitle: true,
      ),
      body: const _LoginForm(),
    );
  }
}
