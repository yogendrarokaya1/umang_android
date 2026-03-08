import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/api/api_client.dart';
import 'package:fitness_tracker/core/api/api_endpoints.dart';
import 'package:fitness_tracker/features/goal/data/models/goal_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalRemoteDatasourceProvider = Provider<IGoalRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return GoalRemoteDatasource(apiClient);
});

abstract class IGoalRemoteDatasource {
  Future<List<GoalModel>> getGoals({String? status, String? type});
  Future<GoalModel> createGoal(Map<String, dynamic> data);
  Future<GoalModel> markComplete(String id);
  Future<GoalModel> markAbandoned(String id);
  Future<GoalSummaryModel> getSummary();
}

class GoalRemoteDatasource implements IGoalRemoteDatasource {
  final ApiClient _apiClient;

  GoalRemoteDatasource(this._apiClient);

  @override
  Future<List<GoalModel>> getGoals({String? status, String? type}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (type != null && type.isNotEmpty) queryParams['type'] = type;

      final response = await _apiClient.get(ApiEndpoints.goals, queryParameters: queryParams);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data['goals'];
        return data.map((json) => GoalModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load goals');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<GoalModel> createGoal(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.goals, data: data);
      if (response.statusCode == 201) {
        return GoalModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to create goal');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<GoalModel> markComplete(String id) async {
    try {
      final response = await _apiClient.patch(ApiEndpoints.completeGoal(id));
      if (response.statusCode == 200) {
        return GoalModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to complete goal');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<GoalModel> markAbandoned(String id) async {
    try {
      final response = await _apiClient.patch(ApiEndpoints.abandonGoal(id));
      if (response.statusCode == 200) {
        return GoalModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to abandon goal');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<GoalSummaryModel> getSummary() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.goalsSummary);
      if (response.statusCode == 200) {
        return GoalSummaryModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch goal summary');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
