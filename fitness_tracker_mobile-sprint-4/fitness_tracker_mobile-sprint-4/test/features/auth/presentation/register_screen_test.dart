import 'package:fitness_tracker/features/auth/presentation/pages/signup_page.dart';
import 'package:fitness_tracker/features/auth/presentation/state/auth_state.dart';
import 'package:fitness_tracker/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthViewModel extends AuthViewModel with Mock {}

void main() {
  late MockAuthViewModel mockAuthViewModel;

  setUp(() {
    mockAuthViewModel = MockAuthViewModel();
    when(() => mockAuthViewModel.build()).thenReturn(const AuthState(status: AuthStatus.initial));
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(() => mockAuthViewModel),
      ],
      child: const MaterialApp(
        home: RegisterScreen(),
      ),
    );
  }

  group('RegisterScreen Widget Tests', () {
    testWidgets('Should display fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(TextFormField), findsNWidgets(4));
    });

    testWidgets('Should show title', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());
       expect(find.text('Create Account'), findsOneWidget);
    });
  });
}
