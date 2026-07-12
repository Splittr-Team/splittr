import 'package:freezed_annotation/freezed_annotation.dart';

part 'input_split.freezed.dart';

@freezed
sealed class InputSplit with _$InputSplit {
  const factory InputSplit.equal({
    required String userId,
  }) = EqualInputSplit;

  const factory InputSplit.exact({
    required String userId,
    required num amount,
  }) = ExactInputSplit;

  const factory InputSplit.percentage({
    required String userId,
    required num percentage,
  }) = PercentageInputSplit;
}
