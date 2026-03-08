import 'package:fitness_tracker/features/workout/data/models/workout_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Workout Model Unit Tests', () {
    test('WorkoutPlanModel.fromJson should parse nested days and exercises', () {
      final json = {
        '_id': 'plan1',
        'userId': 'u1',
        'name': 'Power Lifting',
        'difficulty': 'advanced',
        'days': [
          {
            '_id': 'day1',
            'dayNumber': 1,
            'name': 'Chest Day',
            'exercises': [
              {
                '_id': 'pe1',
                'exerciseId': 'ex1',
                'sets': 3,
                'reps': 10,
                'restSec': 90,
                'order': 1,
              }
            ]
          }
        ]
      };

      final model = WorkoutPlanModel.fromJson(json);

      expect(model.id, 'plan1');
      expect(model.days.length, 1);
      expect(model.days[0].name, 'Chest Day');
      expect(model.days[0].exercises[0].exerciseId, 'ex1');
      expect(model.days[0].exercises[0].sets, 3);
    });

    test('PlanExerciseModel.toJson should return correct map', () {
      const model = PlanExerciseModel(
        id: 'pe1',
        exerciseId: 'ex1',
        sets: 4,
        reps: 12,
        restSec: 60,
        order: 1,
      );

      final json = model.toJson();

      expect(json['exerciseId'], 'ex1');
      expect(json['sets'], 4);
      expect(json['reps'], 12);
    });

    test('WorkoutDayModel initialization', () {
      const model = WorkoutDayModel(
        id: 'd1',
        dayNumber: 1,
        name: 'Rest',
        exercises: [],
      );
      expect(model.name, 'Rest');
    });
  });
}
