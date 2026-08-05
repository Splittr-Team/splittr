import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/friends/presentation/blocs/friends_bloc.dart';
import 'package:splittr/features/friends/presentation/ui/friends_page.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friends_empty_state.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friends_list_view.dart';
import 'package:splittr/l10n/generated/app_localizations.dart';

class MockFriendsBloc extends Mock implements FriendsBloc {}

void main() {
  late MockFriendsBloc mockFriendsBloc;

  setUpAll(() {
    registerFallbackValue(noParams);
  });

  setUp(() async {
    mockFriendsBloc = MockFriendsBloc();
    when(() => mockFriendsBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockFriendsBloc.started(any())).thenReturn(null);
    when(() => mockFriendsBloc.close()).thenAnswer((_) => Future.value());

    if (getIt.isRegistered<FriendsBloc>()) {
      await getIt.unregister<FriendsBloc>();
    }
    getIt.registerFactory<FriendsBloc>(() => mockFriendsBloc);
  });

  Widget buildTestableWidget(FriendsState state) {
    when(() => mockFriendsBloc.state).thenReturn(state);

    return const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: FriendsPage(),
      ),
    );
  }

  group('FriendsForm / FriendsPage', () {
    testWidgets(
      'renders AppRefreshIndicator with empty state in ListView '
      'when friends list is empty',
      (tester) async {
        const state = FriendsState.initial(
          store: FriendsStateStore(friends: []),
        );

        await tester.pumpWidget(buildTestableWidget(state));

        expect(find.byType(AppRefreshIndicator), findsOneWidget);
        expect(find.byType(FriendsEmptyState), findsOneWidget);

        final listViewFinder = find.byType(ListView);
        expect(listViewFinder, findsOneWidget);

        final listView = tester.widget<ListView>(listViewFinder);
        expect(listView.physics, isA<AlwaysScrollableScrollPhysics>());
      },
    );

    testWidgets(
      'renders AppRefreshIndicator with FriendsListView '
      'when friends list is non-empty',
      (tester) async {
        const state = FriendsState.onFriendsUpdated(
          store: FriendsStateStore(
            friends: [
              User(id: '1', name: 'Alice', email: 'alice@example.com'),
            ],
          ),
        );

        await tester.pumpWidget(buildTestableWidget(state));

        expect(find.byType(AppRefreshIndicator), findsOneWidget);
        expect(find.byType(FriendsListView), findsOneWidget);
      },
    );

    testWidgets(
      'invokes started(noParams) on refresh gesture',
      (tester) async {
        const state = FriendsState.initial(
          store: FriendsStateStore(friends: []),
        );

        await tester.pumpWidget(buildTestableWidget(state));

        await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        verify(() => mockFriendsBloc.started(noParams)).called(2);
      },
    );
  });
}
