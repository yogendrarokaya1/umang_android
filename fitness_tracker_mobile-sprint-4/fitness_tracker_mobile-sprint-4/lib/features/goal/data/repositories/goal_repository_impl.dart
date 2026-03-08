import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/goal/data/datasources/goal_remote_datasource.dart';
import 'package:fitness_tracker/features/goal/data/models/goal_model.dart';
import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IGoalRepository {
  Future<Either<Failure, List<GoalEntity>>> getGoals({String? status, String? type});
  Future<Either<Failure, GoalEntity>> createGoal(GoalEntity goal);
  Future<Either<Failure, GoalEntity>> markComplete(String id);
  Future<Either<Failure, GoalEntity>> markAbandoned(String id);
  Future<Either<Failure, GoalSummaryEntity>> getSummary();
}

final goalRepositoryProvider = Provider<IGoalRepository>((ref) {
  final remoteDatasource = ref.read(goalRemoteDatasourceProvider);
  return GoalRepositoryImpl(remoteDatasource);
});

class GoalRepositoryImpl implements IGoalRepository {
  final IGoalRemoteDatasource _remoteDatasource;

  GoalRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<GoalEntity>>> getGoals({String? status, String? type}) async {
    try {
      final goals = await _remoteDatasource.getGoals(status: status, type: type);
      return Right(goals);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoalEntity>> createGoal(GoalEntity goal) async {
    try {
      final model = GoalModel.fromEntity(goal);
      final createdGoal = await _remoteDatasource.createGoal(model.toJson());
      return Right(createdGoal);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoalEntity>> markComplete(String id) async {
    try {
      final updatedGoal = await _remoteDatasource.markComplete(id);
      return Right(updatedGoal);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoalEntity>> markAbandoned(String id) async {
    try {
      final updatedGoal = await _remoteDatasource.markAbandoned(id);
      return Right(updatedGoal);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoalSummaryEntity>> getSummary() async {
    try {
      final summary = await _remoteDatasource.getSummary();
      return Right(summary);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
