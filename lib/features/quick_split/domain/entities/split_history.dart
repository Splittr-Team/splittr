import 'package:freezed_annotation/freezed_annotation.dart';

part 'split_history.freezed.dart';

@freezed
abstract class SplitHistory with _$SplitHistory {
  const factory SplitHistory({
    required String id,
    required String title,
    required num totalAmount,
    required Map<String, num> individualShares,
    required DateTime createdAt,
  }) = _SplitHistory;
}
