import 'package:fitness_tracker/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Model Unit Tests', () {
    test('AuthHiveModel should convert to entity correctly', () {
      const model = AuthHiveModel(
        authId: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        username: 'johndoe',
      );

      final entity = model.toEntity();

      expect(entity.authId, '123');
      expect(entity.fullName, 'John Doe');
      expect(entity.email, 'john@example.com');
      expect(entity.username, 'johndoe');
    });

    test('AuthHiveModel initialization should work', () {
      const model = AuthHiveModel(
        authId: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        username: 'johndoe',
      );
      expect(model.authId, '123');
    });
  });
}
