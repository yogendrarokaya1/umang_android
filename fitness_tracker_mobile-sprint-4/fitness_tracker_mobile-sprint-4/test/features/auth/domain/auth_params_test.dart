import 'package:fitness_tracker/features/auth/domain/usecases/login_usecase.dart';
import 'package:fitness_tracker/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Params Unit Tests', () {
    test('LoginParams should store correct values', () {
      const params = LoginParams(email: 'test@example.com', password: 'password123');
      expect(params.email, 'test@example.com');
      expect(params.password, 'password123');
    });

    test('RegisterParams should store correct values', () {
      const params = RegisterParams(
        fullName: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
      );
      expect(params.fullName, 'Test User');
      expect(params.email, 'test@example.com');
      expect(params.username, 'testuser');
      expect(params.password, 'password123');
    });
  });
}
