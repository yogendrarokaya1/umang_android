import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';
import 'package:fitness_tracker/features/goal/domain/usecases/create_goal_usecase.dart';
import 'package:fitness_tracker/features/goal/domain/usecases/get_goal_summary_usecase.dart';
import 'package:fitness_tracker/features/goal/domain/usecases/get_goals_usecase.dart';
import 'package:fitness_tracker/features/goal/domain/usecases/mark_goal_abandoned_usecase.dart';
import 'package:fitness_tracker/features/goal/presentation/state/goal_state.dart';
import 'package:fitness_tracker/features/goal/presentation/view_model/goal_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGoalsUsecase extends Mock implements GetGoalsUsecase {}
class MockGetGoalSummaryUsecase extends Mock implements GetGoalSummaryUsecase {}
class MockCreateGoalUsecase extends Mock implements CreateGoalUsecase {}
class MockMarkGoalAbandonedUsecase extends Mock implements MarkGoalAbandonedUsecase {}

void main() {
  late ProviderContainer container;
  late MockGetGoalsUsecase mockGetGoalsUsecase;
  late MockGetGoalSummaryUsecase mockGetGoalSummaryUsecase;

  setUp(() {
    mockGetGoalsUsecase = MockGetGoalsUsecase();
    mockGetGoalSummaryUsecase = MockGetGoalSummaryUsecase();

    container = ProviderContainer(
      overrides: [
        getGoalsUsecaseProvider.overrideWithValue(mockGetGoalsUsecase),
        getGoalSummaryUsecaseProvider.overrideWithValue(mockGetGoalSummaryUsecase),
        createGoalUsecaseProvider.overrideWithValue(MockCreateGoalUsecase()),
        markGoalAbandonedUsecaseProvider.overrideWithValue(MockMarkGoalAbandonedUsecase()),
      ],
    );
  });

  group('GoalViewModel Unit Tests', () {
    test('Initial state is initial', () {
      final state = container.read(goalViewModelProvider);
      expect(state.status, GoalStatus.initial);
    });

    test('getGoals should update status and list', () async {
      final goals = [
        const GoalEntity(id: '1', userId: 'u1', type: 'weight', title: 'Test', status: 'active'),
      ];

      when(() => mockGetGoalsUsecase()).thenAnswer((_) async => Right(goals));

      final notifier = container.read(goalViewModelProvider.notifier);
      await notifier.getGoals();

      final state = container.read(goalViewModelProvider);
      expect(state.status, GoalStatus.success);
      expect(state.goals, goals);
    });

    test('getSummary should update summary data', () async {
      const summary = GoalSummaryEntity(active: 5, completed: 2, abandoned: 1, overdue: 0);

      when(() => mockGetGoalSummaryUsecase()).thenAnswer((_) async => const Right(summary));

      final notifier = container.read(goalViewModelProvider.notifier);
      await notifier.getSummary();

      final state = container.read(goalViewModelProvider);
      expect(state.summary, summary);
    });
  });
}
