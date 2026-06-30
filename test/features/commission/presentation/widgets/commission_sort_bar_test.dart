import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_filter.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_listing.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/widgets/commission_sort_bar.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  Widget bar({
    CommissionFilter filter = const CommissionFilter(),
    ValueChanged<CommissionSort>? onSortSelected,
    VoidCallback? onOpenFilter,
  }) =>
      wrap(
        CommissionSortBar(
          filter: filter,
          onSortSelected: onSortSelected ?? (_) {},
          onOpenFilter: onOpenFilter ?? () {},
        ),
      );

  testWidgets('renders the sort chips and the filter chip', (tester) async {
    await tester.pumpWidget(bar());

    expect(find.text('commission.sort.score_short'.tr()), findsOneWidget);
    expect(find.text('commission.sort.price_short'.tr()), findsOneWidget);
    expect(find.text('commission.sort.nearest_short'.tr()), findsOneWidget);
    expect(find.text('commission.filter'.tr()), findsOneWidget);
  });

  testWidgets('tapping the score chip fires onSortSelected with score',
      (tester) async {
    CommissionSort? selected;
    await tester.pumpWidget(bar(onSortSelected: (s) => selected = s));

    await tester.tap(find.text('commission.sort.score_short'.tr()));
    expect(selected, CommissionSort.score);
  });

  testWidgets('tapping the price chip fires onSortSelected with priceDesc',
      (tester) async {
    CommissionSort? selected;
    await tester.pumpWidget(bar(onSortSelected: (s) => selected = s));

    await tester.tap(find.text('commission.sort.price_short'.tr()));
    expect(selected, CommissionSort.priceDesc);
  });

  testWidgets('tapping the nearest chip fires onSortSelected with nearest',
      (tester) async {
    CommissionSort? selected;
    await tester.pumpWidget(bar(onSortSelected: (s) => selected = s));

    await tester.tap(find.text('commission.sort.nearest_short'.tr()));
    expect(selected, CommissionSort.nearest);
  });

  testWidgets('tapping the filter chip fires onOpenFilter', (tester) async {
    var opened = 0;
    await tester.pumpWidget(bar(onOpenFilter: () => opened++));

    await tester.tap(find.text('commission.filter'.tr()));
    expect(opened, 1);
  });

  testWidgets('price chip reads as selected for priceAsc too', (tester) async {
    await tester.pumpWidget(
      bar(filter: const CommissionFilter(sort: CommissionSort.priceAsc)),
    );

    expect(find.text('commission.sort.price_short'.tr()), findsOneWidget);
  });

  testWidgets('filter chip shows the active state when statuses are set',
      (tester) async {
    await tester.pumpWidget(
      bar(
        filter: const CommissionFilter(
          statuses: {CommissionStatus.available},
        ),
      ),
    );

    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
  });
}
