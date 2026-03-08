import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';
import 'package:fitness_tracker/features/goal/data/repositories/goal_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createGoalUsecaseProvider = Provider<CreateGoalUsecase>((ref) {
  final repository = ref.read(goalRepositoryProvider);
  return CreateGoalUsecase(repository);
});

class CreateGoalUsecase {
  final IGoalRepository _repository;

  CreateGoalUsecase(this._repository);

  Future<Either<Failure, GoalEntity>> call(GoalEntity goal) async {
    return await _repository.createGoal(goal);
  }
}
