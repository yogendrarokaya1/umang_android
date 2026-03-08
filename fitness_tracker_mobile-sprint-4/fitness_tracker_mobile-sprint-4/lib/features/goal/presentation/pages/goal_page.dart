import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';
import 'package:fitness_tracker/features/goal/domain/usecases/mark_goal_abandoned_usecase.dart';
import 'package:fitness_tracker/features/goal/domain/usecases/mark_goal_complete_usecase.dart';
import 'package:fitness_tracker/features/goal/presentation/pages/create_goal_page.dart';
import 'package:fitness_tracker/features/goal/presentation/state/goal_state.dart';
import 'package:fitness_tracker/features/goal/presentation/view_model/goal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalPage extends ConsumerStatefulWidget {
  const GoalPage({super.key});

  @override
  ConsumerState<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends ConsumerState<GoalPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalViewModelProvider.notifier).fetchGoals();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goalState = ref.watch(goalViewModelProvider);
    
    final active = goalState.goals.where((g) => g.status == 'active').toList();
    final completed = goalState.goals.where((g) => g.status == 'completed').toList();
    final abandoned = goalState.goals.where((g) => g.status == 'abandoned').toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Goals', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 28, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateGoalPage()));
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
            Tab(text: 'ACTIVE'),
            Tab(text: 'COMPLETED'),
            Tab(text: 'ABANDONED'),
          ],
        ),
      ),
      body: _buildBody(goalState, active, completed, abandoned),
    );
  }

  Widget _buildBody(GoalState state, List<GoalEntity> active, List<GoalEntity> completed, List<GoalEntity> abandoned) {
    if (state.status == GoalStatus.loading && state.goals.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.black));
    }

    if (state.status == GoalStatus.error && state.goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.errorMessage}', style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () => ref.read(goalViewModelProvider.notifier).fetchGoals(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildGoalList(active, state),
        _buildGoalList(completed, state),
        _buildGoalList(abandoned, state),
      ],
    );
  }

  Widget _buildGoalList(List<GoalEntity> list, GoalState state) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No goals found in this category', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.read(goalViewModelProvider.notifier).fetchGoals(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _GoalCard(goal: list[index]);
        },
      ),
    );
  }
}

class _GoalCard extends ConsumerWidget {
  final GoalEntity goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = goal.progressPercent ?? 0.0;
    
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
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(6)),
                child: Text(goal.type.replaceAll('_', ' ').toUpperCase(), style: TextStyle(color: Colors.blue[700], fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              if (goal.daysRemaining != null && goal.daysRemaining! > 0)
                Text('${goal.daysRemaining} days left', style: TextStyle(color: _getDaysColor(goal.daysRemaining!), fontSize: 12, fontWeight: FontWeight.w600)),
              if (goal.isOverdue == true && goal.status == 'active')
                const Text('Overdue', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(goal.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${goal.currentValue} / ${goal.targetValue} ${goal.unit ?? ''}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[100],
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
            ),
          ),
          const SizedBox(height: 8),
          Text('${progress.toStringAsFixed(1)}% Completed', style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
          
          if (goal.status == 'active') ...[
            const SizedBox(height: 16),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    final res = await ref.read(markGoalAbandonedUsecaseProvider).call(goal.id);
                    res.fold(
                      (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
                      (r) => ref.read(goalViewModelProvider.notifier).fetchGoals(),
                    );
                  },
                  child: const Text('Abandon', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final res = await ref.read(markGoalCompleteUsecaseProvider).call(goal.id);
                    res.fold(
                      (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
                      (r) => ref.read(goalViewModelProvider.notifier).fetchGoals(),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, elevation: 0),
                  child: const Text('Complete'),
                )
              ],
            )
          ]
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 100) return Colors.green;
    if (progress > 50) return Colors.blue;
    return Colors.black87;
  }

  Color _getDaysColor(int days) {
    if (days <= 3) return Colors.red;
    if (days <= 7) return Colors.orange;
    return Colors.grey[600]!;
  }
}
