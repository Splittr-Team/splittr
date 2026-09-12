import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart'
    show AppButton, AppSnackBar;
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    this.onPressed,
    this.fullWidth = true,
    super.key,
  });

  final VoidCallback? onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final button = AppButton.outlined(
      text: context.strings.continueWithGoogle,
      icon: Icons.g_mobiledata_rounded,
      onPressed:
          onPressed ??
          () => AppSnackBar.show(
            context,
            message: context.strings.socialSignInComingSoon,
          ),
    );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
