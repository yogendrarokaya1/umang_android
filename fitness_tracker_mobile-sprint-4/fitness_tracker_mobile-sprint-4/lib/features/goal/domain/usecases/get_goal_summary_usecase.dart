import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';
import 'package:fitness_tracker/features/goal/data/repositories/goal_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getGoalSummaryUsecaseProvider = Provider<GetGoalSummaryUsecase>((ref) {
  final repository = ref.read(goalRepositoryProvider);
  return GetGoalSummaryUsecase(repository);
});

class GetGoalSummaryUsecase {
  final IGoalRepository _repository;

  GetGoalSummaryUsecase(this._repository);

  Future<Either<Failure, GoalSummaryEntity>> call() async {
    return await _repository.getSummary();
  }
}
