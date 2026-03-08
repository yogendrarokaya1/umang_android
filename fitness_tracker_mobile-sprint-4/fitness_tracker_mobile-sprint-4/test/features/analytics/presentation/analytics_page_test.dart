import 'package:fitness_tracker/features/analytics/domain/entities/analytics_dashboard_entity.dart';
import 'package:fitness_tracker/features/analytics/presentation/pages/analytics_page.dart';
import 'package:fitness_tracker/features/analytics/presentation/state/analytics_state.dart';
import 'package:fitness_tracker/features/analytics/presentation/view_model/analytics_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsViewModel extends AnalyticsViewModel with Mock {}

void main() {
  late MockAnalyticsViewModel mockAnalyticsViewModel;

  setUp(() {
    mockAnalyticsViewModel = MockAnalyticsViewModel();
    when(() => mockAnalyticsViewModel.build()).thenReturn(const AnalyticsState(status: AnalyticsStatus.initial));
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        analyticsViewModelProvider.overrideWith(() => mockAnalyticsViewModel),
      ],
      child: const MaterialApp(
        home: AnalyticsPage(),
      ),
    );
  }

  group('AnalyticsPage Widget Tests', () {
    testWidgets('Should display dashboard title', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());
       expect(find.text('Analytics Dashboard'), findsOneWidget);
    });

    testWidgets('Should show loading state', (tester) async {
       when(() => mockAnalyticsViewModel.state).thenReturn(const AnalyticsState(status: AnalyticsStatus.loading));
       await tester.pumpWidget(createWidgetUnderTest());
       expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
