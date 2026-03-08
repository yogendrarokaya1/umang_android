import 'package:equatable/equatable.dart';
import 'package:fitness_tracker/features/analytics/domain/entities/analytics_entity.dart';

enum AnalyticsStatus { initial, loading, success, error }

class AnalyticsState extends Equatable {
  final AnalyticsStatus status;
  final AnalyticsDashboardEntity? dashboard;
  final String? errorMessage;

  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.dashboard,
    this.errorMessage,
  });

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsDashboardEntity? dashboard,
    String? errorMessage,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, dashboard, errorMessage];
}
