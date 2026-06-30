import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/stats_row.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders both stat cards with labels, values and icons',
      (tester) async {
    await tester.pumpWidget(
      wrap(const StatsRow(activeListings: 12, potentialCustomers: 28)),
    );

    expect(find.text('home.active_listings'.tr()), findsOneWidget);
    expect(find.text('home.potential_customers'.tr()), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('28'), findsOneWidget);

    expect(find.byIcon(Icons.maps_home_work_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_search_outlined), findsOneWidget);
  });
}
