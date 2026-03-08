import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/workout/data/datasources/workout_remote_datasource.dart';
import 'package:fitness_tracker/features/workout/data/models/workout_model.dart';
import 'package:fitness_tracker/features/workout/domain/entities/exercise_entity.dart';
import 'package:fitness_tracker/features/workout/domain/entities/workout_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IWorkoutRepository {
  Future<Either<Failure, List<WorkoutPlanEntity>>> getMyPlans();
  Future<Either<Failure, List<WorkoutPlanEntity>>> getPublicPlans();
  Future<Either<Failure, WorkoutPlanEntity>> getPlanById(String id);
  Future<Either<Failure, WorkoutPlanEntity>> createPlan(WorkoutPlanEntity plan);
  Future<Either<Failure, List<ExerciseEntity>>> getExercises({String? query, String? category});
}

final workoutRepositoryProvider = Provider<IWorkoutRepository>((ref) {
  final remoteDatasource = ref.read(workoutRemoteDatasourceProvider);
  return WorkoutRepositoryImpl(remoteDatasource);
});

class WorkoutRepositoryImpl implements IWorkoutRepository {
  final IWorkoutRemoteDatasource _remoteDatasource;

  WorkoutRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<WorkoutPlanEntity>>> getMyPlans() async {
    try {
      final plans = await _remoteDatasource.getMyPlans();
      return Right(plans);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutPlanEntity>> getPlanById(String id) async {
    try {
      final plan = await _remoteDatasource.getPlanById(id);
      return Right(plan);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutPlanEntity>>> getPublicPlans() async {
    try {
      final plans = await _remoteDatasource.getPublicPlans();
      return Right(plans);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutPlanEntity>> createPlan(WorkoutPlanEntity plan) async {
    try {
      final model = WorkoutPlanModel.fromEntity(plan);
      final createdPlan = await _remoteDatasource.createPlan(model.toJson());
      return Right(createdPlan);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getExercises({String? query, String? category}) async {
    try {
      final exercises = await _remoteDatasource.getExercises(query: query, category: category);
      return Right(exercises);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
