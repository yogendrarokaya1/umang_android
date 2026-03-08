import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/api/api_client.dart';
import 'package:fitness_tracker/core/api/api_endpoints.dart';
import 'package:fitness_tracker/features/workout/data/models/exercise_model.dart';
import 'package:fitness_tracker/features/workout/data/models/workout_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutRemoteDatasourceProvider = Provider<IWorkoutRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return WorkoutRemoteDatasource(apiClient);
});

abstract class IWorkoutRemoteDatasource {
  Future<List<WorkoutPlanModel>> getMyPlans();
  Future<List<WorkoutPlanModel>> getPublicPlans();
  Future<WorkoutPlanModel> getPlanById(String id);
  Future<WorkoutPlanModel> createPlan(Map<String, dynamic> data);
  Future<List<ExerciseModel>> getExercises({String? query, String? category});
}

class WorkoutRemoteDatasource implements IWorkoutRemoteDatasource {
  final ApiClient _apiClient;

  WorkoutRemoteDatasource(this._apiClient);

  @override
  Future<List<WorkoutPlanModel>> getMyPlans() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.myPlans);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['plans'] ?? response.data['data'] ?? [];
        return data.map((json) => WorkoutPlanModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load workout plans');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<WorkoutPlanModel> getPlanById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.planById(id));
      if (response.statusCode == 200) {
        return WorkoutPlanModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to load workout plan');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<WorkoutPlanModel>> getPublicPlans() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.publicPlans);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['plans'] ?? response.data['data'] ?? [];
        return data.map((json) => WorkoutPlanModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load public workout plans');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<WorkoutPlanModel> createPlan(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.plans, data: data);
      if (response.statusCode == 201) {
        return WorkoutPlanModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to create workout plan');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<ExerciseModel>> getExercises({String? query, String? category}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (query != null) queryParams['search'] = query;
      if (category != null) queryParams['category'] = category;

      final response = await _apiClient.get(
        ApiEndpoints.exercises,
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['exercises'] ?? response.data['data'] ?? [];
        return data.map((json) => ExerciseModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load exercises');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
