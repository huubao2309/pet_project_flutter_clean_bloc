import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_listing.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/widgets/commission_card.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/status_badge.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  CommissionListing listing({
    CommissionStatus status = CommissionStatus.available,
    int? expiresInDays,
  }) =>
      CommissionListing(
        id: 'c1',
        title: 'The Marq Quận 1',
        address: 'Quận 1, TP. HCM',
        distanceKm: 1.2,
        price: 8500000000,
        commissionRate: 0.03,
        commissionAmount: 255000000,
        commissionScore: 9.4,
        type: 'Căn hộ',
        status: status,
        expiresInDays: expiresInDays,
      );

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders title and the commission payout pill', (tester) async {
    await tester.pumpWidget(wrap(CommissionCard(listing: listing())));

    expect(find.text('The Marq Quận 1'), findsOneWidget);
    expect(find.byType(StatusBadge), findsOneWidget);
    // Payout pill: "HH 3,0% · ..." — percent rendered with a comma.
    expect(find.textContaining('HH 3,0%'), findsOneWidget);
    // Distance line includes the formatted km.
    expect(find.textContaining('1,2 km'), findsOneWidget);
  });

  testWidgets('invokes onTap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      wrap(CommissionCard(listing: listing(), onTap: () => tapped++)),
    );

    await tester.tap(find.byType(CommissionCard));
    expect(tapped, 1);
  });

  testWidgets('shows the expiry tag when the listing is expiring soon',
      (tester) async {
    await tester.pumpWidget(
      wrap(CommissionCard(listing: listing(expiresInDays: 2))),
    );

    expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
    expect(find.textContaining('còn 2 ngày'), findsOneWidget);
  });

  testWidgets('hides the expiry tag when there is no expiry pressure',
      (tester) async {
    await tester.pumpWidget(
      wrap(CommissionCard(listing: listing(expiresInDays: 10))),
    );

    expect(find.byIcon(Icons.schedule_rounded), findsNothing);
  });

  testWidgets('covers every commission status style', (tester) async {
    for (final status in CommissionStatus.values) {
      await tester
          .pumpWidget(wrap(CommissionCard(listing: listing(status: status))));
      expect(find.byType(StatusBadge), findsOneWidget);
    }

    // The urgent-sell status carries a leading flame icon.
    await tester.pumpWidget(
      wrap(
        CommissionCard(
          listing: listing(status: CommissionStatus.urgentSell),
        ),
      ),
    );
    expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
  });
}
