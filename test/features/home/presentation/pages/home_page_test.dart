import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/pages/home_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/view_model/home_view_model.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/deal_tile.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/home_header.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/property_card.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/quick_actions.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/stats_row.dart';

import '../../../../helpers/feature_test_harness.dart';

void main() {
  setUpAll(() {
    FeatureTestHarness.bootstrap();
  });

  setUp(() {
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<HomeViewModel>(HomeViewModel.new);
  });

  testWidgets('shows a loading indicator before the data resolves',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, const HomePage());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Drain the pending Future.delayed so the timer test does not leak.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('renders the dashboard once loaded', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const HomePage());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(HomeHeader), findsOneWidget);
    expect(find.byType(QuickActions), findsOneWidget);
    expect(find.byType(StatsRow), findsOneWidget);
    expect(find.byType(PropertyCard), findsWidgets);
    expect(find.byType(DealTile), findsWidgets);
  });

  testWidgets('pull-to-refresh re-runs the loader', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const HomePage());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    await tester.fling(find.byType(HomeHeader), const Offset(0, 400), 1000);
    await tester.pump();
    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(HomeHeader), findsOneWidget);
  });
}
