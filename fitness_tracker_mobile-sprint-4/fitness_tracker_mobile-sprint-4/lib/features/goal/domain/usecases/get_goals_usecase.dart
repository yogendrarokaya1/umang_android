import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';
import 'package:fitness_tracker/features/goal/data/repositories/goal_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getGoalsUsecaseProvider = Provider<GetGoalsUsecase>((ref) {
  final repo = ref.read(goalRepositoryProvider);
  return GetGoalsUsecase(repo);
});

class GetGoalsUsecase {
  final IGoalRepository _repository;

  GetGoalsUsecase(this._repository);

  Future<Either<Failure, List<GoalEntity>>> call({String? status, String? type}) async {
    return await _repository.getGoals(status: status, type: type);
  }
}
