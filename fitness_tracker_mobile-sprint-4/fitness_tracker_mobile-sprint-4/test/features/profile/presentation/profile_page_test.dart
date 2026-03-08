import 'package:fitness_tracker/features/auth/domain/entities/auth_entity.dart';
import 'package:fitness_tracker/features/auth/presentation/state/auth_state.dart';
import 'package:fitness_tracker/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_tracker/features/profile/presentation/pages/profile_page.dart';
import 'package:fitness_tracker/features/profile/presentation/state/profile_state.dart';
import 'package:fitness_tracker/features/profile/presentation/view_model/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileViewModel extends ProfileViewModel with Mock {}
class MockAuthViewModel extends AuthViewModel with Mock {}

void main() {
  late MockProfileViewModel mockProfileViewModel;
  late MockAuthViewModel mockAuthViewModel;

  setUp(() {
    mockProfileViewModel = MockProfileViewModel();
    mockAuthViewModel = MockAuthViewModel();
    
    when(() => mockAuthViewModel.build()).thenReturn(const AuthState(status: AuthStatus.initial));
    when(() => mockProfileViewModel.build()).thenReturn(const ProfileState(status: ProfileStatus.initial));
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        profileViewModelProvider.overrideWith(() => mockProfileViewModel),
        authViewModelProvider.overrideWith(() => mockAuthViewModel),
      ],
      child: const MaterialApp(
        home: ProfilePage(),
      ),
    );
  }

  group('ProfilePage Widget Tests', () {
    testWidgets('Should display user info', (tester) async {
       final user = const AuthEntity(
        authId: '1',
        fullName: 'John Doe',
        email: 'john@example.com',
        username: 'johndoe',
      );

      when(() => mockAuthViewModel.state).thenReturn(AuthState(status: AuthStatus.authenticated, user: user));
      when(() => mockProfileViewModel.state).thenReturn(const ProfileState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Should show logout icon', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());
       expect(find.byIcon(Icons.logout), findsOneWidget);
    });
  });
}
