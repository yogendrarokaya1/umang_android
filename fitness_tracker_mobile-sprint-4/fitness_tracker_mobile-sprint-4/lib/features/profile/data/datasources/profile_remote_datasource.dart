import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/api/api_client.dart';
import 'package:fitness_tracker/core/api/api_endpoints.dart';
import 'package:fitness_tracker/features/profile/data/models/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRemoteDatasourceProvider = Provider<IProfileRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ProfileRemoteDatasource(apiClient);
});

abstract class IProfileRemoteDatasource {
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> updateMyProfile(Map<String, dynamic> data);
  Future<ProfileDashboardModel> getDashboard();
  Future<BodyMetricModel> logBodyMetric(Map<String, dynamic> data);
}

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ApiClient _apiClient;

  ProfileRemoteDatasource(this._apiClient);

  @override
  Future<ProfileModel> getMyProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.myProfile);
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to load profile');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<ProfileModel> updateMyProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(ApiEndpoints.myProfile, data: data);
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to update profile');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<ProfileDashboardModel> getDashboard() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.myDashboard);
      if (response.statusCode == 200) {
        return ProfileDashboardModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch profile dashboard');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<BodyMetricModel> logBodyMetric(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.myBodyMetrics, data: data);
      if (response.statusCode == 201) {
        return BodyMetricModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to log body metric');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
