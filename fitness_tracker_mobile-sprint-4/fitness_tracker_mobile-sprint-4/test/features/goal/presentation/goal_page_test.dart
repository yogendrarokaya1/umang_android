import 'package:fitness_tracker/features/goal/presentation/pages/goal_page.dart';
import 'package:fitness_tracker/features/goal/presentation/state/goal_state.dart';
import 'package:fitness_tracker/features/goal/presentation/view_model/goal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGoalViewModel extends GoalViewModel with Mock {}

void main() {
  late MockGoalViewModel mockGoalViewModel;

  setUp(() {
    mockGoalViewModel = MockGoalViewModel();
    when(() => mockGoalViewModel.build()).thenReturn(const GoalState(status: GoalStatus.initial));
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        goalViewModelProvider.overrideWith(() => mockGoalViewModel),
      ],
      child: const MaterialApp(
        home: GoalPage(),
      ),
    );
  }

  group('GoalPage Widget Tests', () {
    testWidgets('Should display page title', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());
       expect(find.text('My Fitness Goals'), findsOneWidget);
    });

    testWidgets('Should show loading state', (tester) async {
       when(() => mockGoalViewModel.state).thenReturn(const GoalState(status: GoalStatus.loading));
       await tester.pumpWidget(createWidgetUnderTest());
       expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
