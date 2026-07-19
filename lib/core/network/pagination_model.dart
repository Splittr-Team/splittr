import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/core/network/pagination.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
class PaginationModel {
  const PaginationModel({
    required this.hasMore,
    this.nextCursor,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  final bool hasMore;
  final String? nextCursor;

  Pagination toDomain() => Pagination(
    hasMore: hasMore,
    nextCursor: nextCursor,
  );
}
