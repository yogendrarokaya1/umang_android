import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';
import 'package:fitness_tracker/features/goal/data/repositories/goal_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final markGoalAbandonedUsecaseProvider = Provider<MarkGoalAbandonedUsecase>((ref) {
  final repository = ref.read(goalRepositoryProvider);
  return MarkGoalAbandonedUsecase(repository);
});

class MarkGoalAbandonedUsecase {
  final IGoalRepository _repository;

  MarkGoalAbandonedUsecase(this._repository);

  Future<Either<Failure, GoalEntity>> call(String id) async {
    return await _repository.markAbandoned(id);
  }
}
