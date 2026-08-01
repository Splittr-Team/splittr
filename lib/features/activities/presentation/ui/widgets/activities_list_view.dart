import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/presentation/widgets/paginated_list_view.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';
import 'package:splittr/features/activities/presentation/ui/widgets/activity_item_card.dart';

class ActivitiesListView extends StatelessWidget {
  const ActivitiesListView({
    required this.activities,
    required this.hasMore,
    required this.isLoadingMore,
    this.onLoadMore,
    super.key,
  });

  final List<Activity> activities;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    return PaginatedListView<Activity>(
      items: activities,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      onLoadMore: onLoadMore ?? () {},
      padding: const EdgeInsets.all(AppSpacing.md),
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, activity, index) {
        return ActivityItemCard(activity: activity);
      },
    );
  }
}
