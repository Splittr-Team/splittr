part of 'media_picker_cubit.dart';

@freezed
sealed class MediaPickerState with _$MediaPickerState {
  const factory MediaPickerState.initial() = MediaPickerInitialState;
  const factory MediaPickerState.loading() = MediaPickerLoadingState;
  const factory MediaPickerState.success(File file) = MediaPickerSuccessState;
  const factory MediaPickerState.failure(MediaPickerFailure failure) =
      MediaPickerErrorState;
}
