import 'package:fitness_tracker/features/workout/domain/entities/workout_entity.dart';
import 'package:fitness_tracker/features/workout/domain/entities/exercise_entity.dart';
import 'package:fitness_tracker/features/workout/domain/usecases/create_workout_plan_usecase.dart';
import 'package:fitness_tracker/features/workout/domain/usecases/get_exercises_usecase.dart';
import 'package:fitness_tracker/features/workout/presentation/view_model/workout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CreateWorkoutPage extends ConsumerStatefulWidget {
  const CreateWorkoutPage({super.key});

  @override
  ConsumerState<CreateWorkoutPage> createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends ConsumerState<CreateWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _weeksController = TextEditingController();
  
  String _difficulty = 'beginner';
  bool _isPublic = false;
  bool _isSubmitting = false;

  final List<WorkoutDayEntity> _days = [];
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    // Start with one day by default
    _addDay();
  }

  void _addDay() {
    setState(() {
      _days.add(WorkoutDayEntity(
        id: _uuid.v4(),
        dayNumber: _days.length + 1,
        name: 'Day ${_days.length + 1}',
        exercises: const [],
      ));
    });
  }

  void _removeDay(int index) {
    setState(() {
      _days.removeAt(index);
      // Re-number days
      for (int i = 0; i < _days.length; i++) {
        final old = _days[i];
        _days[i] = WorkoutDayEntity(
          id: old.id,
          dayNumber: i + 1,
          name: old.name.startsWith('Day ') ? 'Day ${i + 1}' : old.name,
          exercises: old.exercises,
        );
      }
    });
  }

  void _addExercise(int dayIndex, ExerciseEntity exercise) {
    setState(() {
      final day = _days[dayIndex];
      final newExercises = List<PlanExerciseEntity>.from(day.exercises);
      newExercises.add(PlanExerciseEntity(
        id: _uuid.v4(),
        exerciseId: exercise.id,
        sets: 3,
        reps: 10,
        restSec: 60,
        order: newExercises.length + 1,
        notes: null,
      ));
      
      _days[dayIndex] = WorkoutDayEntity(
        id: day.id,
        dayNumber: day.dayNumber,
        name: day.name,
        exercises: newExercises,
      );
    });
  }

  void _removeExercise(int dayIndex, int exerciseIndex) {
    setState(() {
      final day = _days[dayIndex];
      final newExercises = List<PlanExerciseEntity>.from(day.exercises);
      newExercises.removeAt(exerciseIndex);
      
      _days[dayIndex] = WorkoutDayEntity(
        id: day.id,
        dayNumber: day.dayNumber,
        name: day.name,
        exercises: newExercises,
      );
    });
  }

  void _updateExercise(int dayIndex, int exerciseIndex, {int? sets, int? reps, int? rest}) {
    setState(() {
      final day = _days[dayIndex];
      final newExercises = List<PlanExerciseEntity>.from(day.exercises);
      final old = newExercises[exerciseIndex];
      
      newExercises[exerciseIndex] = PlanExerciseEntity(
        id: old.id,
        exerciseId: old.exerciseId,
        sets: sets ?? old.sets,
        reps: reps ?? old.reps,
        restSec: rest ?? old.restSec,
        order: old.order,
        notes: old.notes,
      );
      
      _days[dayIndex] = WorkoutDayEntity(
        id: day.id,
        dayNumber: day.dayNumber,
        name: day.name,
        exercises: newExercises,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _weeksController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_days.isEmpty || _days.any((d) => d.exercises.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please ensure every workout day has at least one exercise.'), backgroundColor: Colors.orange)
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final plan = WorkoutPlanEntity(
      id: '',
      userId: '',
      name: _nameController.text,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      difficulty: _difficulty,
      durationWeeks: _weeksController.text.isNotEmpty ? int.parse(_weeksController.text) : null,
      isPublic: _isPublic,
      days: _days,
    );

    final res = await ref.read(createWorkoutPlanUsecaseProvider).call(plan);
    
    if (mounted) {
      setState(() => _isSubmitting = false);
      res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${l.message}'), backgroundColor: Colors.red)),
        (r) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout Plan created!'), backgroundColor: Colors.green));
          ref.read(workoutViewModelProvider.notifier).fetchMyPlans();
          Navigator.of(context).pop();
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Workout Plan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Plan Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildTextField('Plan Name', _nameController, 'e.g. 30 Days Shred'),
                const SizedBox(height: 16),
                _buildTextField('Description', _descriptionController, 'Brief explanation...', maxLines: 2, requiredField: false),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown('Difficulty', _difficulty, ['beginner', 'intermediate', 'advanced'], (val) {
                        if (val != null) setState(() => _difficulty = val);
                      }),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField('Weeks', _weeksController, 'e.g. 4', isNumber: true),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Workout Days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: _addDay,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Day'),
                      style: TextButton.styleFrom(foregroundColor: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ...List.generate(_days.length, (index) => _buildDayCard(index)),
                
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Make Public', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Allow others in the community to use this plan.', style: TextStyle(fontSize: 12)),
                  value: _isPublic,
                  onChanged: (val) => setState(() => _isPublic = val),
                  contentPadding: EdgeInsets.zero,
                  activeColor: Colors.black,
                ),
                
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isSubmitting 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('Save Workout Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(int index) {
    final day = _days[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(day.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(
                  onPressed: () => _removeDay(index),
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (day.exercises.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(child: Text('No exercises added yet', style: TextStyle(color: Colors.grey, fontSize: 13))),
            ),
          ...List.generate(day.exercises.length, (exIndex) => _buildExerciseRow(index, exIndex)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: OutlinedButton.icon(
              onPressed: () => _showExercisePicker(index),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Exercise'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseRow(int dayIndex, int exIndex) {
    final ex = _days[dayIndex].exercises[exIndex];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Exercise ID: ${ex.exerciseId.substring(0, 8)}...', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildInlineEdit(
                      'Sets: ', 
                      ex.sets.toString(), 
                      (val) => _updateExercise(dayIndex, exIndex, sets: int.tryParse(val)),
                    ),
                    const SizedBox(width: 12),
                    _buildInlineEdit(
                      'Reps: ', 
                      ex.reps.toString(), 
                      (val) => _updateExercise(dayIndex, exIndex, reps: int.tryParse(val)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeExercise(dayIndex, exIndex),
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineEdit(String label, String value, ValueChanged<String> onSubmitted) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        SizedBox(
          width: 30,
          height: 20,
          child: TextField(
            controller: TextEditingController(text: value),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            onSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }

  void _showExercisePicker(int dayIndex) async {
    final ExerciseEntity? picked = await showDialog<ExerciseEntity>(
      context: context,
      builder: (context) => const ExercisePickerDialog(),
    );
    if (picked != null) {
      _addExercise(dayIndex, picked);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool isNumber = false, int maxLines = 1, bool requiredField = true}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[50],
        floatingLabelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
      ),
      validator: requiredField ? (v) => v!.isEmpty ? 'Required' : null : null,
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: options.map((opt) {
        return DropdownMenuItem(
          value: opt,
          child: Text(opt.replaceAll('_', ' ').replaceFirst(opt[0], opt[0].toUpperCase())),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
      ),
    );
  }
}

class ExercisePickerDialog extends ConsumerStatefulWidget {
  const ExercisePickerDialog({super.key});

  @override
  ConsumerState<ExercisePickerDialog> createState() => _ExercisePickerDialogState();
}

class _ExercisePickerDialogState extends ConsumerState<ExercisePickerDialog> {
  String _searchQuery = '';
  List<ExerciseEntity> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final res = await ref.read(getExercisesUsecaseProvider).call(query: _searchQuery);
    if (mounted) {
      res.fold(
        (l) => setState(() => _isLoading = false),
        (r) => setState(() {
          _exercises = r;
          _isLoading = false;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pick Exercise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (val) {
                _searchQuery = val;
                _loadExercises();
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.black))
                : _exercises.isEmpty
                  ? const Center(child: Text('No exercises found'))
                  : ListView.builder(
                      itemCount: _exercises.length,
                      itemBuilder: (context, index) {
                        final ex = _exercises[index];
                        return ListTile(
                          title: Text(ex.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(ex.category.replaceFirst(ex.category[0], ex.category[0].toUpperCase())),
                          trailing: const Icon(Icons.add, size: 20),
                          onTap: () => Navigator.pop(context, ex),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
