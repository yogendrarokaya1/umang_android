import 'package:fitness_tracker/features/analytics/domain/entities/analytics_entity.dart';

class AnalyticsDashboardModel extends AnalyticsDashboardEntity {
  const AnalyticsDashboardModel({
    required super.bodyTrends,
    required super.measurementTrends,
    required super.goalProgress,
    required super.workoutStats,
  });

  factory AnalyticsDashboardModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsDashboardModel(
      bodyTrends: json['bodyTrends'] ?? {},
      measurementTrends: json['measurementTrends'] ?? {},
      goalProgress: json['goalProgress'] ?? {},
      workoutStats: json['workoutStats'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bodyTrends': bodyTrends,
      'measurementTrends': measurementTrends,
      'goalProgress': goalProgress,
      'workoutStats': workoutStats,
    };
  }

  factory AnalyticsDashboardModel.fromEntity(AnalyticsDashboardEntity entity) {
    return AnalyticsDashboardModel(
      bodyTrends: entity.bodyTrends,
      measurementTrends: entity.measurementTrends,
      goalProgress: entity.goalProgress,
      workoutStats: entity.workoutStats,
    );
  }
}
