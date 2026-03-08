import 'package:fitness_tracker/features/profile/data/models/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Profile Model Unit Tests', () {
    test('ProfileModel.fromJson should return a valid model', () {
      final json = {
        '_id': 'p1',
        'userId': 'u1',
        'gender': 'male',
        'heightCm': 180,
        'fitnessLevel': 'intermediate',
      };

      final model = ProfileModel.fromJson(json);

      expect(model.id, 'p1');
      expect(model.gender, 'male');
      expect(model.heightCm, 180.0);
      expect(model.fitnessLevel, 'intermediate');
    });

    test('BodyMetricModel.fromJson mapping', () {
      final json = {
        '_id': 'm1',
        'weightKg': 80.5,
        'recordedAt': '2026-03-08T10:00:00Z',
      };

      final model = BodyMetricModel.fromJson(json);
      expect(model.weightKg, 80.5);
      expect(model.id, 'm1');
    });
  });
}
