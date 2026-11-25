import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_media_kit/sky_media_kit.dart';

part 'media_picker_cubit.freezed.dart';
part 'media_picker_state.dart';

@injectable
final class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit(this._mediaPickerService)
    : super(const MediaPickerState.initial());

  final MediaPickerService _mediaPickerService;

  Future<void> pickImage(
    ImageSource source, {
    int maxSizeBytes = 5 * 1024 * 1024,
    int imageQuality = 85,
  }) async {
    emit(const MediaPickerState.loading());

    final result = await _mediaPickerService.pickImage(
      source: source,
      maxSizeBytes: maxSizeBytes,
      imageQuality: imageQuality,
    );

    emit(
      switch (result) {
        Left(value: MediaPickerCancelledFailure()) =>
          const MediaPickerState.initial(),
        Left(:final value) => MediaPickerState.failure(value),
        Right(:final value) => MediaPickerState.success(File(value.path)),
      },
    );
  }
}
