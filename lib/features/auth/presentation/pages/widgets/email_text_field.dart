import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppTextField;
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      keyboardType: .emailAddress,
      labelText: context.strings.email,
      hintText: context.strings.emailHintText,
      onChanged: onChanged,
      validator: (email) {
        if (email?.isNotEmpty ?? false) {
          return EmailAddress(
            email ?? '',
          ).value.fold((failure) => failure.message, (_) => null);
        }

        return null;
      },
    );
  }
}
