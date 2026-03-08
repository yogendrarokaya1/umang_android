import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/api/api_client.dart';
import 'package:fitness_tracker/core/api/api_endpoints.dart';
import 'package:fitness_tracker/features/analytics/data/models/analytics_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsRemoteDatasourceProvider = Provider<IAnalyticsRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AnalyticsRemoteDatasource(apiClient);
});

abstract class IAnalyticsRemoteDatasource {
  Future<AnalyticsDashboardModel> getDashboard();
}

class AnalyticsRemoteDatasource implements IAnalyticsRemoteDatasource {
  final ApiClient _apiClient;

  AnalyticsRemoteDatasource(this._apiClient);

  @override
  Future<AnalyticsDashboardModel> getDashboard() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.analyticsDashboard);
      if (response.statusCode == 200) {
        return AnalyticsDashboardModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to load analytics dashboard');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
