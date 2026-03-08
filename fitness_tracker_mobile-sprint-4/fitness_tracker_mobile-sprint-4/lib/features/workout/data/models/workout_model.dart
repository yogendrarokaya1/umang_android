import 'package:fitness_tracker/features/workout/domain/entities/workout_entity.dart';

class WorkoutPlanModel extends WorkoutPlanEntity {
  const WorkoutPlanModel({
    required super.id,
    required super.userId,
    required super.name,
    super.description,
    required super.difficulty,
    super.durationWeeks,
    required super.isPublic,
    required super.days,
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      difficulty: json['difficulty'] ?? 'beginner',
      durationWeeks: json['durationWeeks'] as int?,
      isPublic: json['isPublic'] ?? false,
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => WorkoutDayModel.fromJson(e))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'durationWeeks': durationWeeks,
      'isPublic': isPublic,
      'days': days.map((e) => (e as WorkoutDayModel).toJson()).toList(),
    };
  }

  factory WorkoutPlanModel.fromEntity(WorkoutPlanEntity entity) {
    return WorkoutPlanModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      difficulty: entity.difficulty,
      durationWeeks: entity.durationWeeks,
      isPublic: entity.isPublic,
      days: entity.days.map((e) => WorkoutDayModel.fromEntity(e)).toList(),
    );
  }
}

class WorkoutDayModel extends WorkoutDayEntity {
  const WorkoutDayModel({
    required super.id,
    required super.dayNumber,
    required super.name,
    required super.exercises,
  });

  factory WorkoutDayModel.fromJson(Map<String, dynamic> json) {
    return WorkoutDayModel(
      id: json['_id'] ?? json['id'] ?? '',
      dayNumber: json['dayNumber'] ?? 1,
      name: json['name'] ?? '',
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => PlanExerciseModel.fromJson(e))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'name': name,
      'exercises': exercises.map((e) => (e as PlanExerciseModel).toJson()).toList(),
    };
  }

  factory WorkoutDayModel.fromEntity(WorkoutDayEntity entity) {
    return WorkoutDayModel(
      id: entity.id,
      dayNumber: entity.dayNumber,
      name: entity.name,
      exercises: entity.exercises.map((e) => PlanExerciseModel.fromEntity(e)).toList(),
    );
  }
}

class PlanExerciseModel extends PlanExerciseEntity {
  const PlanExerciseModel({
    required super.id,
    required super.exerciseId,
    super.sets,
    super.reps,
    super.durationSec,
    required super.restSec,
    super.notes,
    required super.order,
  });

  factory PlanExerciseModel.fromJson(Map<String, dynamic> json) {
    return PlanExerciseModel(
      id: json['_id'] ?? json['id'] ?? '',
      exerciseId: json['exerciseId'] ?? '',
      sets: json['sets'] as int?,
      reps: json['reps'] as int?,
      durationSec: json['durationSec'] as int?,
      restSec: json['restSec'] ?? 60,
      notes: json['notes'],
      order: json['order'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'durationSec': durationSec,
      'restSec': restSec,
      'notes': notes,
      'order': order,
    };
  }

  factory PlanExerciseModel.fromEntity(PlanExerciseEntity entity) {
    return PlanExerciseModel(
      id: entity.id,
      exerciseId: entity.exerciseId,
      sets: entity.sets,
      reps: entity.reps,
      durationSec: entity.durationSec,
      restSec: entity.restSec,
      notes: entity.notes,
      order: entity.order,
    );
  }
}
