import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';

class PaginatedListView<T> extends StatefulWidget {
  const PaginatedListView({
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.hasMore,
    required this.isLoadingMore,
    this.separatorBuilder,
    this.padding,
    super.key,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final EdgeInsetsGeometry? padding;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * 0.9) {
      if (widget.hasMore && !widget.isLoadingMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.items.length + (widget.hasMore ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: totalCount,
      separatorBuilder: (context, index) {
        if (index < widget.items.length - 1 &&
            widget.separatorBuilder != null) {
          return widget.separatorBuilder!(context, index);
        }
        return const SizedBox.shrink();
      },
      itemBuilder: (context, index) {
        if (index == widget.items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.gutter),
            child: Center(
              child: AppProgressIndicator.circular(),
            ),
          );
        }

        return widget.itemBuilder(context, widget.items[index], index);
      },
    );
  }
}
