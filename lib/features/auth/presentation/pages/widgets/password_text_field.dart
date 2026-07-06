import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_design_system/sky_design_system.dart'
    show AppIconButton, AppTextField;
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late final ValueNotifier<bool> _obscureText;

  @override
  void initState() {
    _obscureText = ValueNotifier(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _obscureText,
      builder: (context, obscureText, _) {
        return AppTextField(
          labelText: context.strings.password,
          hintText: context.strings.passwordHintText,
          obscureText: obscureText,
          onChanged: widget.onChanged,
          suffixIcon: ExcludeFocus(
            child: AppIconButton(
              icon: obscureText ? Icons.visibility_off : Icons.visibility,
              onPressed: () {
                _obscureText.value = !obscureText;
              },
            ),
          ),
          validator: (password) {
            if (password?.isNotEmpty ?? false) {
              return Password(
                password ?? '',
              ).value.fold((failure) => failure.message, (_) => null);
            }
            return null;
          },
        );
      },
    );
  }
}
