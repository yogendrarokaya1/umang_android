import 'package:fitness_tracker/features/analytics/domain/usecases/get_dashboard_usecase.dart';
import 'package:fitness_tracker/features/analytics/presentation/state/analytics_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsViewModelProvider = NotifierProvider<AnalyticsViewModel, AnalyticsState>(
  AnalyticsViewModel.new,
);

class AnalyticsViewModel extends Notifier<AnalyticsState> {
  late final GetDashboardUsecase _getDashboardUsecase;

  @override
  AnalyticsState build() {
    _getDashboardUsecase = ref.read(getDashboardUsecaseProvider);
    return const AnalyticsState();
  }

  Future<void> fetchDashboard() async {
    state = state.copyWith(status: AnalyticsStatus.loading);

    final result = await _getDashboardUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AnalyticsStatus.error,
        errorMessage: failure.message,
      ),
      (dashboard) => state = state.copyWith(
        status: AnalyticsStatus.success,
        dashboard: dashboard,
      ),
    );
  }
}
