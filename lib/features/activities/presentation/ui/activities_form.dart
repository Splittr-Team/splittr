part of 'activities_page.dart';

class _ActivitiesForm extends StatelessWidget {
  const _ActivitiesForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, state) {
        return switch (state) {
          Initial _ || ChangeLoaderState _
              when state.store.activities.isEmpty =>
            const ActivitiesShimmerList(),
          OnFailure(:final failure) when state.store.activities.isEmpty =>
            ActivitiesErrorState(
              message: failure.message,
              onRetry: () => getBloc<ActivitiesBloc>(context).started(noParams),
            ),
          _ =>
            state.store.activities.isEmpty
                ? AppRefreshIndicator(
                    onRefresh: () async {
                      getBloc<ActivitiesBloc>(context).started(noParams);
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: AppSpacing.xxl),
                        ActivitiesEmptyState(),
                      ],
                    ),
                  )
                : AppRefreshIndicator(
                    onRefresh: () async {
                      getBloc<ActivitiesBloc>(context).started(noParams);
                    },
                    child: ActivitiesListView(
                      activities: state.store.activities,
                      hasMore: state.store.hasMore,
                      isLoadingMore: state.store.loading,
                      onLoadMore: () =>
                          getBloc<ActivitiesBloc>(context).fetchNextPage(),
                    ),
                  ),
        };
      },
    );
  }
}
