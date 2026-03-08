import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';
import 'package:fitness_tracker/features/goal/domain/usecases/get_goal_summary_usecase.dart';
import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_tracker/features/profile/domain/usecases/get_profile_dashboard_usecase.dart';
import 'package:fitness_tracker/features/profile/domain/usecases/log_body_metric_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers for the dashboard overview
final dashboardStateProvider = FutureProvider.autoDispose<Map<String, dynamic?>>((ref) async {
  final profileDash = await ref.read(getProfileDashboardUsecaseProvider).call();
  final goalSummary = await ref.read(getGoalSummaryUsecaseProvider).call();
  
  return <String, dynamic?>{
    'profileDashboard': profileDash.fold<ProfileDashboardEntity?>((_) => null, (r) => r),
    'goalSummary': goalSummary.fold<GoalSummaryEntity?>((_) => null, (r) => r),
  };
});

class HomeOverviewPage extends ConsumerStatefulWidget {
  const HomeOverviewPage({super.key});

  @override
  ConsumerState<HomeOverviewPage> createState() => _HomeOverviewPageState();
}

class _HomeOverviewPageState extends ConsumerState<HomeOverviewPage> {
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

  Future<void> _submitMetric() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    final metric = BodyMetricEntity(
      id: '',
      weightKg: double.parse(_weightController.text),
      bodyFatPercent: double.tryParse(_bodyFatController.text),
      recordedAt: DateTime.now(),
    );

    final res = await ref.read(logBodyMetricUsecaseProvider).call(metric);
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${l.message}'), backgroundColor: Colors.red)),
      (r) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Metric Logged!'), backgroundColor: Colors.green));
        _weightController.clear();
        _bodyFatController.clear();
        ref.invalidate(dashboardStateProvider); // Refresh dashboard
      }
    );
    
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsyncValue = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: dashboardAsyncValue.when(
        data: (data) => _buildContent(
          data['profileDashboard'] as ProfileDashboardEntity?,
          data['goalSummary'] as dynamic // GoalSummaryEntity?
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading dashboard: $err'),
              ElevatedButton(
                onPressed: () => ref.invalidate(dashboardStateProvider),
                child: const Text('Retry'),
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _buildContent(ProfileDashboardEntity? profileDash, dynamic goalSummary) {
    final latest = profileDash?.latestMetric;
    final progress30 = profileDash?.progress['last30Days'];

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(dashboardStateProvider),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        children: [
          Text('Your fitness overview', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 24),

          // Stats Row
          Row(
            children: [
              Expanded(child: _buildStatCard('Weight', latest?.weightKg != null ? '${latest!.weightKg} kg' : '—')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('BMI', latest?.bmi != null ? latest!.bmi!.toStringAsFixed(1) : '—')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Body Fat', latest?.bodyFatPercent != null ? '${latest!.bodyFatPercent}%' : '—')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Active Goals', goalSummary?.active?.toString() ?? '—')),
            ],
          ),
          const SizedBox(height: 24),

          // 30 day progress
          if (progress30 != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Last 30 Days', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildProgressItem('Weight change', '${progress30['weightChange'] > 0 ? '+' : ''}${progress30['weightChange']?.toStringAsFixed(1) ?? '0'} kg', (progress30['weightChange'] ?? 0) < 0 ? Colors.green : Colors.red),
                      _buildProgressItem('Avg weight', '${progress30['avgWeight']?.toStringAsFixed(1) ?? '—'} kg', Colors.black),
                      _buildProgressItem('Total logs', '${progress30['totalLogs'] ?? 0}', Colors.black),
                    ],
                  ),
                ],
              )
            ),
            const SizedBox(height: 24),
          ],

          // Goal Summary
          if (goalSummary != null) ...[
             Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Goals', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      Text('View All →', style: TextStyle(color: Colors.blue[600], fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGoalSummaryItem(goalSummary.active.toString(), 'Active', Colors.blue),
                      _buildGoalSummaryItem(goalSummary.completed.toString(), 'Completed', Colors.green),
                      _buildGoalSummaryItem(goalSummary.overdue.toString(), 'Overdue', Colors.orange),
                    ],
                  ),
                ],
              )
            ),
            const SizedBox(height: 24),
          ],

          // Log Metrics Form
           Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Log Today\'s Metrics', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _bodyFatController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Body Fat %',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitMetric,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        child: _isSubmitting 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Save Entry')
                      ),
                    )
                  ],
                ),
              )
           ),
           const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      )
    );
  }

  Widget _buildProgressItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildGoalSummaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }
}
