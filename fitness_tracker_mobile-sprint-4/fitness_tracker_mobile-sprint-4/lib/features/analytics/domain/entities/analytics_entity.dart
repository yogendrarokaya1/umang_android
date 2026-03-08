import 'package:equatable/equatable.dart';

class AnalyticsDashboardEntity extends Equatable {
  final Map<String, dynamic> bodyTrends;
  final Map<String, dynamic> measurementTrends;
  final Map<String, dynamic> goalProgress;
  final Map<String, dynamic> workoutStats;

  const AnalyticsDashboardEntity({
    required this.bodyTrends,
    required this.measurementTrends,
    required this.goalProgress,
    required this.workoutStats,
  });

  @override
  List<Object?> get props => [
        bodyTrends,
        measurementTrends,
        goalProgress,
        workoutStats,
      ];
}
