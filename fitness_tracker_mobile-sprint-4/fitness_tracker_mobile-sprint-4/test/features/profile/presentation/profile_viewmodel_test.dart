import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_tracker/features/profile/domain/usecases/get_dashboard_usecase.dart';
import 'package:fitness_tracker/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_tracker/features/profile/domain/usecases/log_body_metric_usecase.dart';
import 'package:fitness_tracker/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:fitness_tracker/features/profile/presentation/state/profile_state.dart';
import 'package:fitness_tracker/features/profile/presentation/view_model/profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}
class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}
class MockGetDashboardUsecase extends Mock implements GetDashboardUsecase {}
class MockLogBodyMetricUsecase extends Mock implements LogBodyMetricUsecase {}

void main() {
  late ProviderContainer container;
  late MockGetProfileUsecase mockGetProfileUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;

  setUp(() {
    mockGetProfileUsecase = MockGetProfileUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();

    container = ProviderContainer(
      overrides: [
        getProfileUsecaseProvider.overrideWithValue(mockGetProfileUsecase),
        updateProfileUsecaseProvider.overrideWithValue(mockUpdateProfileUsecase),
        getDashboardUsecaseProvider.overrideWithValue(MockGetDashboardUsecase()),
        logBodyMetricUsecaseProvider.overrideWithValue(MockLogBodyMetricUsecase()),
      ],
    );
  });

  group('ProfileViewModel Unit Tests', () {
    test('Initial state should be initial', () {
      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.initial);
    });

    test('getMyProfile should update status to success on success', () async {
      const profile = ProfileEntity(
        id: '1',
        userId: 'u1',
        fitnessLevel: 'beginner',
        activityLevel: 'sedentary',
        preferredWeightUnit: 'kg',
        preferredHeightUnit: 'cm',
      );

      when(() => mockGetProfileUsecase()).thenAnswer((_) async => const Right(profile));

      final notifier = container.read(profileViewModelProvider.notifier);
      await notifier.getMyProfile();

      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.success);
      expect(state.profile, profile);
    });

    test('updateMyProfile should update state', () async {
      const profile = ProfileEntity(
        id: '1',
        userId: 'u1',
        fitnessLevel: 'intermediate',
        activityLevel: 'sedentary',
        preferredWeightUnit: 'kg',
        preferredHeightUnit: 'cm',
      );

      registerFallbackValue(profile);
      when(() => mockUpdateProfileUsecase(any())).thenAnswer((_) async => const Right(profile));

      final notifier = container.read(profileViewModelProvider.notifier);
      await notifier.updateMyProfile(profile);

      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.success);
      expect(state.profile, profile);
    });
  });
}
