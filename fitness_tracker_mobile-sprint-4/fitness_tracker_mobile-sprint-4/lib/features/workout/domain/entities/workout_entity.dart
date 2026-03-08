import 'package:equatable/equatable.dart';

class WorkoutPlanEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String difficulty;
  final int? durationWeeks;
  final bool isPublic;
  final List<WorkoutDayEntity> days;

  const WorkoutPlanEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.difficulty,
    this.durationWeeks,
    required this.isPublic,
    required this.days,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        difficulty,
        durationWeeks,
        isPublic,
        days,
      ];
}

class WorkoutDayEntity extends Equatable {
  final String id;
  final int dayNumber;
  final String name;
  final List<PlanExerciseEntity> exercises;

  const WorkoutDayEntity({
    required this.id,
    required this.dayNumber,
    required this.name,
    required this.exercises,
  });

  @override
  List<Object?> get props => [id, dayNumber, name, exercises];
}

class PlanExerciseEntity extends Equatable {
  final String id;
  final String exerciseId;
  final int? sets;
  final int? reps;
  final int? durationSec;
  final int restSec;
  final String? notes;
  final int order;

  const PlanExerciseEntity({
    required this.id,
    required this.exerciseId,
    this.sets,
    this.reps,
    this.durationSec,
    required this.restSec,
    this.notes,
    required this.order,
  });

  @override
  List<Object?> get props => [
        id,
        exerciseId,
        sets,
        reps,
        durationSec,
        restSec,
        notes,
        order,
      ];
}
