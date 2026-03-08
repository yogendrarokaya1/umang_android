import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/features/auth/domain/entities/auth_entity.dart';
import 'package:fitness_tracker/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fitness_tracker/features/auth/domain/usecases/login_usecase.dart';
import 'package:fitness_tracker/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fitness_tracker/features/auth/domain/usecases/register_usecase.dart';
import 'package:fitness_tracker/features/auth/presentation/state/auth_state.dart';
import 'package:fitness_tracker/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}
class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}
class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late ProviderContainer container;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(mockGetCurrentUserUsecase),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthViewModel Unit Tests', () {
    test('Initial state should be initial', () {
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
    });

    test('login should set loading then authenticated on success', () async {
      const user = AuthEntity(
        authId: '1',
        fullName: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
      );

      registerFallbackValue(const LoginParams(email: '', password: ''));
      when(() => mockLoginUsecase(any())).thenAnswer((_) async => const Right(user));

      final notifier = container.read(authViewModelProvider.notifier);
      await notifier.login(email: 'test@example.com', password: 'password123');

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, user);
    });

    test('logout should clear user and set unauthenticated', () async {
      when(() => mockLogoutUsecase()).thenAnswer((_) async => const Right(true));

      final notifier = container.read(authViewModelProvider.notifier);
      await notifier.logout();

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
    });
  });
}
