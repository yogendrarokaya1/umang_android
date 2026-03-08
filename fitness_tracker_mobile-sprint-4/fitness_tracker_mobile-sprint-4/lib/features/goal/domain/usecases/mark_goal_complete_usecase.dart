import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';
import 'package:fitness_tracker/features/goal/data/repositories/goal_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final markGoalCompleteUsecaseProvider = Provider<MarkGoalCompleteUsecase>((ref) {
  final repository = ref.read(goalRepositoryProvider);
  return MarkGoalCompleteUsecase(repository);
});

class MarkGoalCompleteUsecase {
  final IGoalRepository _repository;

  MarkGoalCompleteUsecase(this._repository);

  Future<Either<Failure, GoalEntity>> call(String id) async {
    return await _repository.markComplete(id);
  }
}
