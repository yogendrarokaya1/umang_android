import 'package:fitness_tracker/features/auth/presentation/pages/login_page.dart';
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
    // Default mock behavior
    when(() => mockAuthViewModel.build()).thenReturn(const AuthState(status: AuthStatus.initial));
    when(() => mockAuthViewModel.state).thenReturn(const AuthState(status: AuthStatus.initial));
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(() => mockAuthViewModel),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('Should display Login title and text fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Login'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('Should toggle password visibility', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());

       // Find the obscure toggler
       await tester.tap(find.byIcon(Icons.visibility));
       await tester.pump();

       // Verify it toggled (internal state of widget)
       expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Should show validation errors', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());
       await tester.tap(find.byType(ElevatedButton));
       await tester.pump();

       expect(find.text('Email is required'), findsOneWidget);
    });
  });
}
