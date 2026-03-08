import 'package:fitness_tracker/features/workout/domain/entities/workout_entity.dart';
import 'package:fitness_tracker/features/workout/presentation/pages/create_workout_page.dart';
import 'package:fitness_tracker/features/workout/presentation/state/workout_state.dart';
import 'package:fitness_tracker/features/workout/presentation/view_model/workout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutPage extends ConsumerStatefulWidget {
  const WorkoutPage({super.key});

  @override
  ConsumerState<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends ConsumerState<WorkoutPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutViewModelProvider.notifier).fetchAll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Plans', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 28, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateWorkoutPage()));
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[500],
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'MY PLANS'),
            Tab(text: 'COMMUNITY'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(workoutState.myPlans, workoutState.myPlansStatus, workoutState.errorMessage, () => ref.read(workoutViewModelProvider.notifier).fetchMyPlans()),
          _buildList(workoutState.publicPlans, workoutState.publicPlansStatus, workoutState.errorMessage, () => ref.read(workoutViewModelProvider.notifier).fetchPublicPlans()),
        ],
      ),
    );
  }

  Widget _buildList(List<WorkoutPlanEntity> plans, WorkoutStatus status, String? error, Future<void> Function() onRefresh) {
    if (status == WorkoutStatus.loading && plans.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.black));
    }

    if (status == WorkoutStatus.error && plans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error', style: const TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: onRefresh, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (plans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No plans found', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: plans.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final plan = plans[index];
          return _PlanCard(plan: plan);
        },
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final WorkoutPlanEntity plan;

  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: _getDifficultyColor(plan.difficulty).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(plan.difficulty.toUpperCase(), style: TextStyle(color: _getDifficultyColor(plan.difficulty), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              if (plan.durationWeeks != null)
                Text('${plan.durationWeeks} Weeks', style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(plan.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (plan.description != null && plan.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(plan.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_month, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text('${plan.days.length} workouts/week', style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
              const Spacer(),
              if (plan.isPublic == true)
                const Icon(Icons.public, size: 16, color: Colors.blue)
            ],
          )
        ],
      ),
    );
  }

  Color _getDifficultyColor(String diff) {
    if (diff == 'beginner') return Colors.green;
    if (diff == 'intermediate') return Colors.orange;
    return Colors.red;
  }
}
