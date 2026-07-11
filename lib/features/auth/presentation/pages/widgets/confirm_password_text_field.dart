import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart' hide State;
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class ConfirmPasswordTextField extends StatefulWidget {
  const ConfirmPasswordTextField({
    required this.onChanged,
    required this.password,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final Password? password;

  @override
  State<ConfirmPasswordTextField> createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState extends State<ConfirmPasswordTextField> {
  late final ValueNotifier<bool> _obscureTextNotifier;

  @override
  void initState() {
    super.initState();
    _obscureTextNotifier = ValueNotifier(true);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _obscureTextNotifier,
      builder: (context, obscureText, _) {
        return AppTextField(
          labelText: context.strings.confirmPassword,
          hintText: context.strings.passwordHintText,
          obscureText: obscureText,
          onChanged: widget.onChanged,
          suffixIcon: ExcludeFocus(
            child: AppIconButton(
              icon: obscureText ? Icons.visibility_off : Icons.visibility,
              onPressed: () {
                _obscureTextNotifier.value = !obscureText;
              },
            ),
          ),
          validator: (confirmPassword) {
            if (confirmPassword?.isNotEmpty ?? false) {
              final passwordText = widget.password?.getOrElse('');
              if (confirmPassword != passwordText) {
                return 'Passwords do not match';
              }
            }
            return null;
          },
        );
      },
    );
  }
}
