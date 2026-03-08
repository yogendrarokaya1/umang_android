import 'package:equatable/equatable.dart';
import 'package:fitness_tracker/features/workout/domain/entities/workout_entity.dart';

enum WorkoutStatus { initial, loading, success, error }

class WorkoutState extends Equatable {
  final WorkoutStatus myPlansStatus;
  final WorkoutStatus publicPlansStatus;
  final List<WorkoutPlanEntity> myPlans;
  final List<WorkoutPlanEntity> publicPlans;
  final String? errorMessage;

  const WorkoutState({
    this.myPlansStatus = WorkoutStatus.initial,
    this.publicPlansStatus = WorkoutStatus.initial,
    this.myPlans = const [],
    this.publicPlans = const [],
    this.errorMessage,
  });

  WorkoutState copyWith({
    WorkoutStatus? myPlansStatus,
    WorkoutStatus? publicPlansStatus,
    List<WorkoutPlanEntity>? myPlans,
    List<WorkoutPlanEntity>? publicPlans,
    String? errorMessage,
  }) {
    return WorkoutState(
      myPlansStatus: myPlansStatus ?? this.myPlansStatus,
      publicPlansStatus: publicPlansStatus ?? this.publicPlansStatus,
      myPlans: myPlans ?? this.myPlans,
      publicPlans: publicPlans ?? this.publicPlans,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [myPlansStatus, publicPlansStatus, myPlans, publicPlans, errorMessage];
}

