import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppImage;
import 'package:splittr/constants/constants.dart';

part 'splash_form.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _SplashForm(),
    );
  }
}
