import 'package:fitness_tracker/features/goal/data/models/goal_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Goal Model Unit Tests', () {
    test('GoalModel.fromJson mapping', () {
      final json = {
        '_id': 'g1',
        'userId': 'u1',
        'type': 'weight',
        'title': 'Lose weight',
        'targetValue': 70.0,
        'status': 'active',
      };

      final model = GoalModel.fromJson(json);

      expect(model.id, 'g1');
      expect(model.type, 'weight');
      expect(model.targetValue, 70.0);
    });

    test('GoalSummaryModel.fromJson mapping', () {
      final json = {
        'active': 2,
        'completed': 1,
        'abandoned': 0,
        'overdue': 0,
      };

      final model = GoalSummaryModel.fromJson(json);
      expect(model.active, 2);
      expect(model.completed, 1);
    });
  });
}
