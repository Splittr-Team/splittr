import 'package:freezed_annotation/freezed_annotation.dart';

part 'split.freezed.dart';

@freezed
sealed class Split with _$Split {
  const factory Split.equal({
    required String userId,
    required num amount,
    required String name,
    String? email,
    String? phone,
  }) = EqualSplit;

  const factory Split.exact({
    required String userId,
    required num amount,
    required num splitValue,
    required String name,
    String? email,
    String? phone,
  }) = ExactSplit;

  const factory Split.percentage({
    required String userId,
    required num amount,
    required num splitValue,
    required String name,
    String? email,
    String? phone,
  }) = PercentageSplit;
}
