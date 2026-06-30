import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/core/utils/currency_format.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/home_header.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  HomeHeader header({String agentName = 'Bảo Nguyễn'}) => HomeHeader(
        agentName: agentName,
        monthlyCommission: 86500000,
        pendingCommission: 42000000,
        dealsClosed: 4,
      );

  testWidgets('renders greeting, role and the agent name', (tester) async {
    await tester.pumpWidget(wrap(header()));

    expect(find.text('home.greeting'.tr()), findsOneWidget);
    expect(find.text('home.role'.tr()), findsOneWidget);
    expect(find.text('Bảo Nguyễn'), findsOneWidget);
  });

  testWidgets('renders the commission card labels and figures', (tester) async {
    await tester.pumpWidget(wrap(header()));

    expect(find.text('home.commission_month'.tr()), findsOneWidget);
    expect(find.text('home.commission_pending'.tr()), findsOneWidget);
    expect(find.text('home.deals_closed'.tr()), findsOneWidget);

    expect(find.text(CurrencyFormat.fullVnd(86500000)), findsOneWidget);
    expect(find.text(CurrencyFormat.compactVnd(42000000)), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('renders the notification icon', (tester) async {
    await tester.pumpWidget(wrap(header()));

    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_wallet_rounded), findsOneWidget);
  });

  testWidgets('derives the avatar initial from the last name word',
      (tester) async {
    await tester.pumpWidget(wrap(header()));
    expect(find.text('N'), findsOneWidget);
  });

  testWidgets('falls back to "?" when the name is blank', (tester) async {
    await tester.pumpWidget(wrap(header(agentName: '   ')));
    expect(find.text('?'), findsOneWidget);
  });
}
