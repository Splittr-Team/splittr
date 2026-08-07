import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/quick_split/presentation/blocs/quick_split_bloc.dart';
import 'package:splittr/features/quick_split/presentation/ui/components/split_history_list.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class SplitHistoryPage extends BasePage<QuickSplitBloc, QuickSplitState> {
  const SplitHistoryPage({super.key});

  @override
  QuickSplitBloc createBloc() => getIt<QuickSplitBloc>()..started(noParams);

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<QuickSplitBloc, QuickSplitState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(context.strings.splitHistory),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        context.strings.appName,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        context.strings.guestMode,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout_rounded),
                  title: Text(context.strings.logout),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer first
                    context.read<AuthBloc>().loggedOut();
                  },
                ),
              ],
            ),
          ),
          body: switch (state) {
            ChangeLoaderState(:final store) when store.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            OnFailure(:final failure) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      context.strings.failedToLoadHistory,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      failure.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: () {
                        getBloc<QuickSplitBloc>(context).add(
                          const QuickSplitEvent.loadHistory(),
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(context.strings.retry),
                    ),
                  ],
                ),
              ),
            ),
            Loaded(:final history) =>
              history.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_toggle_off_rounded,
                              size: 80,
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withAlpha(128),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              context.strings.noPreviousSplits,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              context.strings.createFirstSplitSubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            ElevatedButton.icon(
                              onPressed: () {
                                unawaited(
                                  const QuickSplitRoute().push(context),
                                );
                              },
                              icon: const Icon(Icons.add_rounded),
                              label: Text(context.strings.createYourFirstSplit),
                            ),
                          ],
                        ),
                      ),
                    )
                  : AppRefreshIndicator(
                      onRefresh: () async {
                        getBloc<QuickSplitBloc>(context).add(
                          const QuickSplitEvent.loadHistory(),
                        );
                      },
                      child: SplitHistoryList(history: history),
                    ),
            _ => (() {
              getBloc<QuickSplitBloc>(context).add(
                const QuickSplitEvent.loadHistory(),
              );
              return const Center(child: CircularProgressIndicator());
            })(),
          },
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              unawaited(
                const QuickSplitRoute().push(context),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: Text(context.strings.newSplit),
          ),
        );
      },
    );
  }
}
