import 'package:fitness_tracker/features/goal/domain/usecases/get_goals_usecase.dart';
import 'package:fitness_tracker/features/goal/presentation/state/goal_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalViewModelProvider = NotifierProvider<GoalViewModel, GoalState>(
  GoalViewModel.new,
);

class GoalViewModel extends Notifier<GoalState> {
  late final GetGoalsUsecase _getGoalsUsecase;

  @override
  GoalState build() {
    _getGoalsUsecase = ref.read(getGoalsUsecaseProvider);
    return const GoalState();
  }

  Future<void> fetchGoals() async {
    state = state.copyWith(status: GoalStatus.loading);

    final result = await _getGoalsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: GoalStatus.error,
        errorMessage: failure.message,
      ),
      (goals) => state = state.copyWith(
        status: GoalStatus.success,
        goals: goals,
      ),
    );
  }
}
