import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/section_header.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/status_badge.dart';

import 'helpers/localization_test_harness.dart';

/// Smoke widget tests for a couple of dependency-light dashboard widgets.
///
/// The previous version pumped the whole [MyApp], which now needs the full
/// plugin-backed DI graph (device info, Hive, secure storage) plus the real
/// splash route — not something a plain `flutter test` can build. These tests
/// instead exercise leaf widgets that only depend on the design-system
/// [ThemeState] ([BennyStyleInitializer] registers it without any plugins) and
/// on `.tr()` — which [LocalizationTestHarness.useRealTranslations] makes
/// resolve to the real Vietnamese copy.
void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(body: Center(child: child)),
      );

  group('StatusBadge', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(
        wrap(
          const StatusBadge(
            label: 'Đang bán',
            color: Colors.white,
            background: Colors.green,
          ),
        ),
      );

      expect(find.text('Đang bán'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsNothing);
    });

    testWidgets('renders an optional leading icon', (tester) async {
      await tester.pumpWidget(
        wrap(
          const StatusBadge(
            label: 'Gấp',
            color: Colors.white,
            background: Colors.red,
            icon: Icons.local_fire_department,
          ),
        ),
      );

      expect(find.text('Gấp'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });
  });

  group('SectionHeader', () {
    testWidgets('shows the translated title and "see all" action',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          SectionHeader(
            titleKey: 'home.featured_listings',
            onSeeAll: () => tapped = true,
          ),
        ),
      );

      // `.tr()` resolves to the real Vietnamese copy via the harness.
      expect(find.text('Bất động sản nổi bật'), findsOneWidget);
      expect(find.text('Xem tất cả'), findsOneWidget);

      await tester.tap(find.text('Xem tất cả'));
      expect(tapped, isTrue);
    });

    testWidgets('omits the "see all" action when no callback is given',
        (tester) async {
      await tester.pumpWidget(
        wrap(const SectionHeader(titleKey: 'home.recent_history')),
      );

      expect(find.text('Giao dịch gần đây'), findsOneWidget);
      expect(find.text('Xem tất cả'), findsNothing);
    });
  });
}
