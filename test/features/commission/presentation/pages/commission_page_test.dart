import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/pages/commission_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/view_model/commission_view_model.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/widgets/commission_card.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/widgets/commission_location_banner.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/widgets/commission_sort_bar.dart';

import '../../../../helpers/feature_test_harness.dart';

void main() {
  setUpAll(FeatureTestHarness.bootstrap);

  setUp(() {
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<CommissionViewModel>(
      CommissionViewModel.new,
    );
  });

  /// Pumps the page and advances past the simulated location/fetch delay so the
  /// loaded body is on screen.
  Future<void> pumpLoaded(WidgetTester tester) async {
    await FeatureTestHarness.pumpPage(tester, const CommissionPage());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the locating state before data resolves', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const CommissionPage());
    // Still within the 700ms delay → locating body.
    expect(find.text('commission.locating_title'.tr()), findsOneWidget);
    expect(find.text('commission.locating_subtitle'.tr()), findsOneWidget);

    // Let the pending timer fire to avoid leaking it.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('renders the loaded feed with banner, sort bar and cards',
      (tester) async {
    await pumpLoaded(tester);

    expect(find.text('nav.commission'.tr()), findsOneWidget);
    expect(find.byType(CommissionLocationBanner), findsOneWidget);
    expect(find.byType(CommissionSortBar), findsOneWidget);
    expect(find.byType(CommissionCard), findsWidgets);
  });

  testWidgets('tapping a sort chip re-orders the feed', (tester) async {
    await pumpLoaded(tester);

    await tester.tap(find.text('commission.sort.nearest_short'.tr()));
    await tester.pumpAndSettle();

    expect(find.byType(CommissionCard), findsWidgets);
  });

  testWidgets('opening the filter sheet and applying a status filter',
      (tester) async {
    await pumpLoaded(tester);

    await tester.tap(find.text('commission.filter'.tr()).first);
    await tester.pumpAndSettle();

    // The sheet is open; pick a status (the sheet's chip is rendered last,
    // on top of any matching status badge in a card) and apply.
    await tester.tap(find.text('commission.status.deposited'.tr()).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('commission.apply'.tr()));
    await tester.pumpAndSettle();

    // Only the deposited listing remains (one card).
    expect(find.byType(CommissionCard), findsOneWidget);
  });

  testWidgets('refreshing the location via the AppBar action reloads',
      (tester) async {
    await pumpLoaded(tester);

    // The AppBar action label shows the resolved location when loaded.
    await tester.tap(find.text('Quận 1').first);
    await tester.pump();
    // Goes back to locating, then resolves again.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(CommissionCard), findsWidgets);
  });

  testWidgets('refreshing via the banner refresh icon reloads', (tester) async {
    await pumpLoaded(tester);

    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(CommissionLocationBanner), findsOneWidget);
  });
}
