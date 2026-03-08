import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/workout/domain/entities/workout_entity.dart';
import 'package:fitness_tracker/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createWorkoutPlanUsecaseProvider = Provider<CreateWorkoutPlanUsecase>((ref) {
  final repo = ref.read(workoutRepositoryProvider);
  return CreateWorkoutPlanUsecase(repo);
});

class CreateWorkoutPlanUsecase {
  final IWorkoutRepository _repository;

  CreateWorkoutPlanUsecase(this._repository);

  Future<Either<Failure, WorkoutPlanEntity>> call(WorkoutPlanEntity plan) async {
    return await _repository.createPlan(plan);
  }
}
