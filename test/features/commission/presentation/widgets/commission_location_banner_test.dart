import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/widgets/commission_location_banner.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the location, radius and count', (tester) async {
    await tester.pumpWidget(
      wrap(
        const CommissionLocationBanner(
          locationLabel: 'Quận 1',
          radiusKm: 5,
          count: 12,
        ),
      ),
    );

    expect(find.text('Tin hoa hồng cao gần bạn'), findsOneWidget);
    // Subtitle: "{location} · bán kính {radius} km · {count} tin".
    expect(find.textContaining('Quận 1'), findsOneWidget);
    expect(find.textContaining('5 km'), findsOneWidget);
    expect(find.textContaining('12 tin'), findsOneWidget);
  });

  testWidgets('invokes onRefresh when the refresh icon is tapped',
      (tester) async {
    var refreshed = 0;
    await tester.pumpWidget(
      wrap(
        CommissionLocationBanner(
          locationLabel: 'Quận 1',
          radiusKm: 5,
          count: 12,
          onRefresh: () => refreshed++,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.refresh_rounded));
    expect(refreshed, 1);
  });

  testWidgets('renders without a refresh callback', (tester) async {
    await tester.pumpWidget(
      wrap(
        const CommissionLocationBanner(
          locationLabel: 'Thủ Đức',
          radiusKm: 3,
          count: 0,
        ),
      ),
    );

    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
  });
}
