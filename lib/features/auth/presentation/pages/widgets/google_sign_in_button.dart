import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart'
    show AppButton, AppSnackBar;
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.outlined(
      text: context.strings.google,
      icon: Icons.email,
      onPressed:
          onPressed ??
          () => AppSnackBar.show(
            context,
            message: context.strings.socialSignInComingSoon,
          ),
    );
  }
}
