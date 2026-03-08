import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/workout/domain/entities/exercise_entity.dart';
import 'package:fitness_tracker/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getExercisesUsecaseProvider = Provider<GetExercisesUsecase>((ref) {
  final repository = ref.read(workoutRepositoryProvider);
  return GetExercisesUsecase(repository);
});

class GetExercisesUsecase {
  final IWorkoutRepository _repository;

  GetExercisesUsecase(this._repository);

  Future<Either<Failure, List<ExerciseEntity>>> call({String? query, String? category}) async {
    return await _repository.getExercises(query: query, category: category);
  }
}
