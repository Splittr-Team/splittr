import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/presentation/widgets/media_picker_widget.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/groups/presentation/blocs/create_group/create_group_bloc.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class CreateGroupBottomSheet extends StatelessWidget {
  const CreateGroupBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateGroupBloc>(),
      child: BlocListener<CreateGroupBloc, CreateGroupState>(
        listener: (context, state) => switch (state) {
          OnCreateGroupSuccess(:final iconUploadErrorMessage) => () {
            if (iconUploadErrorMessage != null) {
              AppSnackBar.show(
                context,
                message: iconUploadErrorMessage,
                isError: true,
              );
            }
            RouteHandler.pop<void>(context);
          }(),
          OnFailure(:final failure) => AppSnackBar.show(
            context,
            message: failure.message,
            isError: true,
          ),
          _ => () {},
        },
        child: const _BottomSheetBody(),
      ),
    );
  }
}

class _BottomSheetBody extends StatelessWidget {
  const _BottomSheetBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: BlocSelector<CreateGroupBloc, CreateGroupState, File?>(
            selector: (state) => state.store.groupIcon,
            builder: (context, groupIcon) {
              return MediaPickerWidget(
                maxSizeBytes: 2 * 1024 * 1024,
                sheetTitle: context.strings.changeGroupIcon,
                onImagePicked: (file) {
                  getBloc<CreateGroupBloc>(
                    context,
                  ).groupIconChanged(groupIcon: file);
                },
                builder: (context, showPicker) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: showPicker,
                        child: CircleAvatar(
                          radius: AppRadius.xxl,
                          backgroundColor: context.colorScheme.primaryContainer,
                          backgroundImage: groupIcon != null
                              ? FileImage(groupIcon)
                              : null,
                          child: groupIcon == null
                              ? Icon(
                                  Icons.group_outlined,
                                  size: AppSpacing.xxl,
                                  color: context.colorScheme.onPrimaryContainer,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppButton.text(
                        text: groupIcon == null
                            ? context.strings.changeGroupIcon
                            : context.strings.changePhoto,
                        onPressed: showPicker,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: context.strings.groupName,
          onChanged: (groupName) => getBloc<CreateGroupBloc>(
            context,
          ).groupNameChanged(groupName: groupName),
          validator: (groupName) {
            if (groupName?.isNotEmpty ?? false) {
              return Name(
                groupName ?? '',
              ).value.fold((failure) => failure.message, (_) => null);
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: context.strings.groupDescription,
          onChanged: (groupDescription) => getBloc<CreateGroupBloc>(
            context,
          ).groupDescriptionChanged(groupDescription: groupDescription),
          validator: (groupDescription) {
            if (groupDescription?.isNotEmpty ?? false) {
              return Name(
                groupDescription ?? '',
              ).value.fold((failure) => failure.message, (_) => null);
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        BlocSelector<
          CreateGroupBloc,
          CreateGroupState,
          ({bool isValid, bool isLoading})
        >(
          selector: (state) => (
            isValid:
                state.store.groupName.trim().isNotEmpty &&
                state.store.groupDescription.trim().isNotEmpty,
            isLoading: state.store.loading,
          ),
          builder: (context, record) {
            return AppButton.primary(
              text: context.strings.createGroup,
              onPressed: record.isValid && !record.isLoading
                  ? () => getBloc<CreateGroupBloc>(
                      context,
                    ).createGroupButtonClicked()
                  : null,
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
