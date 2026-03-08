import 'package:fitness_tracker/features/analytics/presentation/state/analytics_state.dart';
import 'package:fitness_tracker/features/analytics/presentation/view_model/analytics_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsViewModelProvider.notifier).fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(analyticsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
      ),
      body: _buildBody(analyticsState),
    );
  }

  Widget _buildBody(AnalyticsState state) {
    if (state.status == AnalyticsStatus.loading && state.dashboard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == AnalyticsStatus.error && state.dashboard == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.errorMessage}'),
            ElevatedButton(
              onPressed: () => ref.read(analyticsViewModelProvider.notifier).fetchDashboard(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final dashboard = state.dashboard;
    if (dashboard == null) {
      return const Center(child: Text('No analytics data available yet.'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(analyticsViewModelProvider.notifier).fetchDashboard(),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStatCard('Goals Progress', dashboard.goalProgress.toString()),
          const SizedBox(height: 16),
          _buildStatCard('Workout Stats', dashboard.workoutStats.toString()),
          const SizedBox(height: 16),
          _buildStatCard('Body Trends', dashboard.bodyTrends.toString()),
          const SizedBox(height: 16),
          _buildStatCard('Measurement Trends', dashboard.measurementTrends.toString()),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Text(data, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
