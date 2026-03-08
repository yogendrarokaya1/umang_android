import 'package:fitness_tracker/features/workout/domain/entities/exercise_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exercise Entity Unit Tests', () {
    test('ExerciseEntity equality should work', () {
      const e1 = ExerciseEntity(
        id: '1',
        name: 'Push Up',
        category: 'strength',
        muscleGroups: ['chest'],
        equipment: ['none'],
        difficulty: 'beginner',
      );

      const e2 = ExerciseEntity(
        id: '1',
        name: 'Push Up',
        category: 'strength',
        muscleGroups: ['chest'],
        equipment: ['none'],
        difficulty: 'beginner',
      );

      expect(e1, e2);
    });

    test('ExerciseEntity should be different if IDs differ', () {
       const e1 = ExerciseEntity(
        id: '1',
        name: 'Push Up',
        category: 'strength',
        muscleGroups: ['chest'],
        equipment: ['none'],
        difficulty: 'beginner',
      );

      const e2 = ExerciseEntity(
        id: '2',
        name: 'Push Up',
        category: 'strength',
        muscleGroups: ['chest'],
        equipment: ['none'],
        difficulty: 'beginner',
      );

      expect(e1, isNot(e2));
    });
  });
}
