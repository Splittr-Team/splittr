import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/route_paths.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/quick_split/presentation/blocs/quick_split_bloc.dart';
import 'package:splittr/features/quick_split/presentation/ui/components/split_history_list.dart';

class SplitHistoryPage extends BasePage<QuickSplitBloc, QuickSplitState> {
  const SplitHistoryPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  QuickSplitBloc createBloc() => getIt<QuickSplitBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<QuickSplitBloc, QuickSplitState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Split History'),
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
                        'Splittr',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Guest Mode',
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
                  title: const Text('Logout'),
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load history',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      failure.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        getBloc<QuickSplitBloc>(context).add(
                          const QuickSplitEvent.loadHistory(),
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            Loaded(:final history) =>
              history.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
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
                            const SizedBox(height: 16),
                            Text(
                              'No previous splits',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create your first split calculation '
                              'to get started!',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                unawaited(
                                  RouteHandler.push<void>(
                                    context,
                                    RoutePaths.quickSplit,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Create Your First Split'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SplitHistoryList(history: history),
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
                RouteHandler.push<void>(context, RoutePaths.quickSplit),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Split'),
          ),
        );
      },
    );
  }
}
