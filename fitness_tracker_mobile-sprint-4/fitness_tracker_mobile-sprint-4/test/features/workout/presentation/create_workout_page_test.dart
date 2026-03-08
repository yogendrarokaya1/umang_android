import 'package:fitness_tracker/features/workout/presentation/pages/create_workout_page.dart';
import 'package:fitness_tracker/features/workout/presentation/state/workout_state.dart';
import 'package:fitness_tracker/features/workout/presentation/view_model/workout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutViewModel extends WorkoutViewModel with Mock {}

void main() {
  late MockWorkoutViewModel mockWorkoutViewModel;

  setUp(() {
    mockWorkoutViewModel = MockWorkoutViewModel();
    when(() => mockWorkoutViewModel.build()).thenReturn(const WorkoutState(myPlansStatus: WorkoutStatus.initial, publicPlansStatus: WorkoutStatus.initial));
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        workoutViewModelProvider.overrideWith(() => mockWorkoutViewModel),
      ],
      child: const MaterialApp(
        home: CreateWorkoutPage(),
      ),
    );
  }

  group('CreateWorkoutPage Widget Tests', () {
    testWidgets('Should display page title', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());
       expect(find.text('Create Workout Plan'), findsOneWidget);
    });

    testWidgets('Should have an Add Day button', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());
       expect(find.text('Add Day'), findsOneWidget);
    });
  });
}
