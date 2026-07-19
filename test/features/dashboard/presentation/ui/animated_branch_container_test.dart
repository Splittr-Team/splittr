import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splittr/features/dashboard/presentation/ui/animated_branch_container.dart';

void main() {
  testWidgets(
    'AnimatedBranchContainer renders active child and animates on index change',
    (tester) async {
      var currentIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Expanded(
                      child: AnimatedBranchContainer(
                        currentIndex: currentIndex,
                        children: const [
                          Text('Tab 0'),
                          Text('Tab 1'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      child: const Text('Switch'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Tab 0'), findsOneWidget);
      expect(
        tester
            .widget<Offstage>(
              find
                  .ancestor(
                    of: find.text('Tab 1', skipOffstage: false),
                    matching: find.byType(Offstage),
                  )
                  .first,
            )
            .offstage,
        true,
      );

      // Switch tabs
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Start animation
      await tester.pumpAndSettle(); // End animation

      expect(find.text('Tab 1'), findsOneWidget);
      expect(
        tester
            .widget<Offstage>(
              find
                  .ancestor(
                    of: find.text('Tab 0', skipOffstage: false),
                    matching: find.byType(Offstage),
                  )
                  .first,
            )
            .offstage,
        true,
      );
    },
  );
}
