import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';

@freezed
class Pagination with _$Pagination {
  const Pagination({
    required this.hasMore,
    this.nextCursor,
  });

  @override
  final bool hasMore;
  @override
  final String? nextCursor;
}

@freezed
class PaginatedList<T> with _$PaginatedList<T> {
  const PaginatedList({
    required this.items,
    required this.pagination,
  });

  @override
  final List<T> items;
  @override
  final Pagination pagination;
}
