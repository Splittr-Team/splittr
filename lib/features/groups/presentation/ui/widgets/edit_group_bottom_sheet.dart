import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class EditGroupBottomSheet extends StatefulWidget {
  const EditGroupBottomSheet({
    required this.group,
    required this.onSave,
    super.key,
  });

  final Group group;
  final void Function(String name, String? description) onSave;

  @override
  State<EditGroupBottomSheet> createState() => _EditGroupBottomSheetState();
}

class _EditGroupBottomSheetState extends State<EditGroupBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _isValid;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.group.description ?? '',
    );
    _isValid = _nameController.text.trim().isNotEmpty;
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    final valid = _nameController.text.trim().isNotEmpty;
    if (valid != _isValid) {
      setState(() {
        _isValid = valid;
      });
    }
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_onNameChanged)
      ..dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _nameController,
          labelText: context.strings.groupName,
          hintText: context.strings.groupName,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: AppIcon.md(Icons.group_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _descriptionController,
          labelText: context.strings.groupDescription,
          hintText: context.strings.groupDescription,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: AppIcon.md(Icons.description_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          text: context.strings.save,
          onPressed: _isValid
              ? () {
                  final name = _nameController.text.trim();
                  final description = _descriptionController.text.trim();
                  widget.onSave(
                    name,
                    description.isEmpty ? null : description,
                  );
                  RouteHandler.pop<void>(context);
                }
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
