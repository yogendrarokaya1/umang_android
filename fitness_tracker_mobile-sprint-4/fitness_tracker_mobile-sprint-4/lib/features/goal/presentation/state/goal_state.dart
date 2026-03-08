import 'package:equatable/equatable.dart';
import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';

enum GoalStatus { initial, loading, success, error }

class GoalState extends Equatable {
  final GoalStatus status;
  final List<GoalEntity> goals;
  final String? errorMessage;

  const GoalState({
    this.status = GoalStatus.initial,
    this.goals = const [],
    this.errorMessage,
  });

  GoalState copyWith({
    GoalStatus? status,
    List<GoalEntity>? goals,
    String? errorMessage,
  }) {
    return GoalState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, goals, errorMessage];
}
