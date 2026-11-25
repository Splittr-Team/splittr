import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_media_kit/sky_media_kit.dart' hide State;
import 'package:splittr/core/presentation/cubits/media_picker_cubit.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class MediaPickerWidget extends StatelessWidget {
  const MediaPickerWidget({
    required this.builder,
    required this.onImagePicked,
    this.maxSizeBytes = 5 * 1024 * 1024,
    this.sheetTitle,
    super.key,
  });

  final Widget Function(BuildContext context, VoidCallback showPicker) builder;
  final ValueChanged<File> onImagePicked;
  final int maxSizeBytes;
  final String? sheetTitle;

  void _showPickerModal(BuildContext context) {
    final cubit = context.read<MediaPickerCubit>();
    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        title: sheetTitle ?? context.strings.changePhoto,
        child: Builder(
          builder: (sheetContext) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppListTile(
                  leadingIcon: Icons.add_a_photo,
                  title: context.strings.takePhoto,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    unawaited(
                      cubit.pickImage(
                        ImageSource.camera,
                        maxSizeBytes: maxSizeBytes,
                      ),
                    );
                  },
                ),
                AppListTile(
                  leadingIcon: Icons.photo_library_outlined,
                  title: context.strings.chooseFromGallery,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    unawaited(
                      cubit.pickImage(
                        ImageSource.gallery,
                        maxSizeBytes: maxSizeBytes,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MediaPickerCubit>(
      create: (_) => getIt<MediaPickerCubit>(),
      child: BlocListener<MediaPickerCubit, MediaPickerState>(
        listener: (context, state) {
          if (!context.mounted) return;

          switch (state) {
            case MediaPickerSuccessState(:final file):
              onImagePicked(file);
            case MediaPickerErrorState(:final failure):
              final message = switch (failure) {
                MediaPermissionDeniedFailure(:final permission) =>
                  context.strings.mediaPermissionDenied(permission ?? 'media'),
                FileSizeExceededFailure(:final message) ||
                InvalidFileTypeFailure(:final message) ||
                CameraCaptureFailure(:final message) ||
                UnknownMediaFailure(
                  :final message,
                ) => context.strings.mediaPickerError(message),
                _ => failure.message,
              };
              AppSnackBar.show(context, message: message);
            case MediaPickerInitialState():
            case MediaPickerLoadingState():
              break;
          }
        },
        child: Builder(
          builder: (context) => builder(
            context,
            () => _showPickerModal(context),
          ),
        ),
      ),
    );
  }
}
