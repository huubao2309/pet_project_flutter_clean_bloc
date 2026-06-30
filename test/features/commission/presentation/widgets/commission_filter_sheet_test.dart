import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_filter.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_listing.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/widgets/commission_filter_sheet.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  /// Pumps a host with a button that opens the filter sheet and captures the
  /// returned filter.
  Future<CommissionFilter?> openSheet(
    WidgetTester tester, {
    CommissionFilter initial = const CommissionFilter(),
  }) async {
    CommissionFilter? result;
    var done = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showCommissionFilterSheet(context, initial);
                  done = true;
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
    expect(done, isFalse);
    return result;
  }

  testWidgets('renders sort options, status chips and action buttons',
      (tester) async {
    await openSheet(tester);

    expect(find.text('commission.filter_title'.tr()), findsOneWidget);
    expect(find.text('commission.sort.score'.tr()), findsOneWidget);
    expect(find.text('commission.sort.price_desc'.tr()), findsOneWidget);
    expect(find.text('commission.sort.price_asc'.tr()), findsOneWidget);
    expect(find.text('commission.sort.nearest'.tr()), findsOneWidget);
    expect(find.text('commission.status.urgent_sell'.tr()), findsOneWidget);
    expect(find.text('commission.status.available'.tr()), findsOneWidget);
    expect(find.text('commission.status.deposited'.tr()), findsOneWidget);
    expect(find.text('commission.apply'.tr()), findsOneWidget);
    expect(find.text('commission.reset'.tr()), findsOneWidget);
  });

  testWidgets('selecting a sort + a status and applying returns the filter',
      (tester) async {
    CommissionFilter? result;
    var done = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showCommissionFilterSheet(
                    context,
                    const CommissionFilter(),
                  );
                  done = true;
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

    await tester.tap(find.text('commission.sort.nearest'.tr()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('commission.status.available'.tr()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('commission.apply'.tr()));
    await tester.pumpAndSettle();

    expect(done, isTrue);
    expect(result, isNotNull);
    expect(result!.sort, CommissionSort.nearest);
    expect(result!.statuses, {CommissionStatus.available});
  });

  testWidgets('toggling a status off removes it from the filter',
      (tester) async {
    CommissionFilter? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showCommissionFilterSheet(
                    context,
                    const CommissionFilter(
                      statuses: {CommissionStatus.deposited},
                    ),
                  );
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

    // Deselect the pre-selected "deposited" chip.
    await tester.tap(find.text('commission.status.deposited'.tr()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('commission.apply'.tr()));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.statuses, isEmpty);
  });

  testWidgets('reset clears the draft back to defaults', (tester) async {
    CommissionFilter? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showCommissionFilterSheet(
                    context,
                    const CommissionFilter(
                      sort: CommissionSort.priceAsc,
                      statuses: {CommissionStatus.urgentSell},
                    ),
                  );
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

    await tester.tap(find.text('commission.reset'.tr()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('commission.apply'.tr()));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.sort, CommissionSort.score);
    expect(result!.statuses, isEmpty);
  });

  testWidgets('dismissing the sheet returns null', (tester) async {
    final result = await openSheet(tester);
    expect(result, isNull);
  });
}
