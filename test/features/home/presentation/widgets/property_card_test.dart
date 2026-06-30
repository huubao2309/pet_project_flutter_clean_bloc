import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/core/utils/currency_format.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/domain/entities/property_listing.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/property_card.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/status_badge.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  PropertyListing listing({
    PropertyStatus status = PropertyStatus.available,
  }) =>
      PropertyListing(
        id: 'p1',
        title: 'Vinhomes Central Park',
        address: 'Bình Thạnh, TP. HCM',
        price: 5600000000,
        area: 78,
        bedrooms: 2,
        type: 'Căn hộ',
        status: status,
      );

  testWidgets('renders title, address, type, price and specs', (tester) async {
    await tester.pumpWidget(wrap(PropertyCard(listing: listing())));

    expect(find.text('Vinhomes Central Park'), findsOneWidget);
    expect(find.text('Bình Thạnh, TP. HCM'), findsOneWidget);
    expect(find.text('Căn hộ'), findsOneWidget);
    expect(find.text(CurrencyFormat.compactVnd(5600000000)), findsOneWidget);
    expect(find.text('78 m²'), findsOneWidget);
    expect(find.text('2 PN'), findsOneWidget);
    expect(find.byType(StatusBadge), findsOneWidget);
  });

  testWidgets('invokes onTap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      wrap(PropertyCard(listing: listing(), onTap: () => tapped++)),
    );

    await tester.tap(find.byType(PropertyCard));
    expect(tapped, 1);
  });

  testWidgets('renders the matching status label for each status',
      (tester) async {
    final labels = {
      PropertyStatus.available: 'property.status.available'.tr(),
      PropertyStatus.deposited: 'property.status.deposited'.tr(),
      PropertyStatus.sold: 'property.status.sold'.tr(),
    };

    for (final entry in labels.entries) {
      await tester.pumpWidget(wrap(PropertyCard(listing: listing(status: entry.key))));
      expect(find.text(entry.value), findsOneWidget);
    }
  });
}
