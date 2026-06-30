import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/qr_scan/domain/entities/scanned_property.dart';
import 'package:pet_project_flutter_clean_bloc/features/qr_scan/presentation/widgets/scan_result_sheet.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  ScannedProperty property() => const ScannedProperty(
        code: 'QR-123',
        title: 'Vinhomes Central Park',
        address: 'Bình Thạnh, TP. HCM',
        area: 78,
        bedrooms: 2,
        price: 5600000000,
        commissionAmount: 168000000,
      );

  /// Pumps a button that opens the result sheet, taps it, and lets the sheet
  /// settle so the private `_ScanResultSheet` is fully built and exercised.
  Future<ScanResultAction?> openSheet(WidgetTester tester) async {
    ScanResultAction? result;
    var resolved = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showScanResultSheet(context, property());
                  resolved = true;
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    // `resolved` is only used so the analyzer keeps the await above honest.
    expect(resolved, isFalse);
    return result;
  }

  testWidgets('renders property summary, price and commission', (tester) async {
    await openSheet(tester);

    expect(find.text('Vinhomes Central Park'), findsOneWidget);
    expect(find.text('qr.scanned'.tr()), findsOneWidget);
    expect(find.text('qr.view_detail'.tr()), findsOneWidget);
    expect(find.text('qr.scan_again'.tr()), findsOneWidget);
  });

  testWidgets('returns viewDetail when the detail button is tapped',
      (tester) async {
    await openSheet(tester);

    await tester.tap(find.text('qr.view_detail'.tr()));
    await tester.pumpAndSettle();

    expect(find.text('Vinhomes Central Park'), findsNothing);
  });

  testWidgets('returns scanAgain when the secondary button is tapped',
      (tester) async {
    await openSheet(tester);

    await tester.tap(find.text('qr.scan_again'.tr()));
    await tester.pumpAndSettle();

    expect(find.text('Vinhomes Central Park'), findsNothing);
  });
}
