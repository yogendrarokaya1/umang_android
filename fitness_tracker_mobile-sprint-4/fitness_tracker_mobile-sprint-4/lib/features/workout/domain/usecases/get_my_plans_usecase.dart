import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/workout/domain/entities/workout_entity.dart';
import 'package:fitness_tracker/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMyPlansUsecaseProvider = Provider<GetMyPlansUsecase>((ref) {
  final repo = ref.read(workoutRepositoryProvider);
  return GetMyPlansUsecase(repo);
});

class GetMyPlansUsecase {
  final IWorkoutRepository _repository;

  GetMyPlansUsecase(this._repository);

  Future<Either<Failure, List<WorkoutPlanEntity>>> call() async {
    return await _repository.getMyPlans();
  }
}
