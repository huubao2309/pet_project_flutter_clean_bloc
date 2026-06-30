import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/domain/entities/deal_record.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/deal_tile.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/status_badge.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  DealRecord deal({DealStatus status = DealStatus.completed}) => DealRecord(
        id: 'd1',
        propertyTitle: 'Masteri Thảo Điền',
        customerName: 'Anh Tuấn',
        dealValue: 4800000000,
        commission: 48000000,
        dateLabel: '12/06/2026',
        status: status,
      );

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the property, commission and a status badge',
      (tester) async {
    await tester.pumpWidget(wrap(DealTile(deal: deal())));

    expect(find.text('Masteri Thảo Điền'), findsOneWidget);
    expect(find.text('+48 tr'), findsOneWidget);
    expect(find.byType(StatusBadge), findsOneWidget);
  });

  testWidgets('invokes onTap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(wrap(DealTile(deal: deal(), onTap: () => tapped++)));

    await tester.tap(find.byType(DealTile));
    expect(tapped, 1);
  });

  testWidgets('covers every deal status style', (tester) async {
    for (final status in DealStatus.values) {
      await tester.pumpWidget(wrap(DealTile(deal: deal(status: status))));
      expect(find.byType(StatusBadge), findsOneWidget);
    }
  });
}
